# Architecture Documentation

This document provides a deep dive into the ProfitMatrix ML Agent architecture, explaining design decisions, data flows, and implementation details.

## Table of Contents

1. [System Overview](#system-overview)
2. [Layer Architecture](#layer-architecture)
3. [Data Pipeline](#data-pipeline)
4. [ML Processing](#ml-processing)
5. [Frontend Design](#frontend-design)
6. [Performance Considerations](#performance-considerations)
7. [Security & Privacy](#security--privacy)
8. [Future Architecture](#future-architecture)

---

## System Overview

The ProfitMatrix ML Agent implements a **3-layer architecture** inspired by AWS SageMaker MLOps best practices:

```
┌────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                       │
│                     (Single-Page Web App)                       │
└────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   DATA LAYER    │────▶│    ML LAYER     │────▶│   APP LAYER     │
│                 │     │                 │     │                 │
│ • RDS Postgres  │     │ • SageMaker     │     │ • Lambda/Node   │
│ • ETL Pipeline  │     │ • K-Means       │     │ • API Gateway   │
│ • S3 Storage    │     │ • Batch/RT      │     │ • React UI      │
│ • Features      │     │ • Model Store   │     │ • Visualization │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

### Key Principles

1. **Separation of Concerns**: Each layer has distinct responsibilities
2. **Loose Coupling**: Layers communicate via well-defined interfaces (S3, API)
3. **Scalability**: Each component can scale independently
4. **Fault Tolerance**: Immutable storage, versioned models, idempotent operations
5. **Cost Optimization**: Batch processing, spot instances, serverless where appropriate

---

## Layer Architecture

### 1. Data Layer

**Purpose**: Collect, store, and prepare data for ML consumption

#### Components

**1.1 RDS PostgreSQL Database**
- **Role**: Source of truth for transactional data
- **Schema**: Multi-tenant (isolated by `tenant_id`)
- **Tables**: 
  - `orders` (invoices, line items, dates)
  - `customers` (accounts, segments, contacts)
  - `products` (SKUs, categories, costs)
  - `pricing` (list prices, discount rules)
  - `costs` (COGS, freight, rebates)
- **Volume**: 4.2M rows across 12 tables
- **Updates**: Real-time inserts/updates from production systems

**1.2 ETL Pipeline (Node.js)**
- **Implementation**: Scheduled Lambda or EC2 cron job
- **Frequency**: Every 15 minutes
- **Logic**:
  ```javascript
  // Pseudo-code
  const lastRun = getLastRunTimestamp();
  const newRows = db.query(`
    SELECT * FROM orders 
    WHERE updated_at > $1 AND tenant_id = $2
  `, [lastRun, tenantId]);
  
  const json = JSON.stringify(newRows);
  s3.putObject(`${tenant}/${date}/${timestamp}.json`, json);
  updateLastRunTimestamp();
  ```
- **Features**:
  - Incremental extraction (timestamp-based)
  - Per-tenant filtering
  - Error handling and retry logic
  - CloudWatch logging

**1.3 S3 Raw Data Bucket**
- **Structure**: `s3://bucket/tenant_id/YYYY/MM/DD/HH-MM-SS.json`
- **Format**: Line-delimited JSON (newline-separated objects)
- **Properties**:
  - Immutable (append-only, never modified)
  - Schema-on-read (flexible for changes)
  - Lifecycle policy (archive to Glacier after 90 days)
- **Size**: 24 GB, 8.3K files

**1.4 Feature Engineering (SageMaker Processing)**
- **Job Type**: SageMaker Processing Job (Python/Pandas)
- **Instance**: ml.m5.xlarge (4 vCPU, 16 GB RAM)
- **Frequency**: Daily batch, triggered by CloudWatch Events
- **Process**:
  1. Read raw JSON from S3
  2. Join orders + customers + products
  3. Compute windowed aggregations:
     ```python
     # Example features
     margin_30d = orders.last_30_days.mean('margin')
     purchase_freq = orders.count() / days_active
     recency_days = (today - orders.last_date).days
     volume_agg = orders.sum('quantity')
     discount_rate = orders.mean('discount_pct')
     ```
  4. Normalize per tenant (z-score)
  5. Write to S3 Feature Store

**1.5 S3 Feature Store**
- **Schema**: 1 row per `(tenant_id, customer_id, time_window)`
- **Format**: Parquet (compressed, columnar)
- **Columns**: 43 features including:
  - `margin_30d`, `margin_90d`, `margin_365d`
  - `purchase_freq`, `recency_days`
  - `volume_agg`, `discount_rate`
  - `payment_term`, `margin_variance`, `growth_rate`
  - ... (35 more)
- **Usage**: Single source of truth for all ML models

---

### 2. ML Layer

**Purpose**: Train models, generate predictions, serve results

#### Components

**2.1 Model Training (SageMaker Training)**
- **Framework**: scikit-learn (K-Means)
- **Job Type**: SageMaker Training Job
- **Instance**: ml.m5.xlarge
- **Frequency**: Weekly (or on-demand)
- **Process**:
  ```python
  # Simplified training code
  from sklearn.cluster import KMeans
  import pandas as pd
  
  # Load features
  df = pd.read_parquet('s3://features/tenant_123/')
  X = df[['margin_30d', 'purchase_freq', 'recency_days', ...]]
  
  # Train model
  kmeans = KMeans(n_clusters=5, random_state=42)
  kmeans.fit(X)
  
  # Save model
  joblib.dump(kmeans, '/opt/ml/model/model.pkl')
  ```
- **Output**: Model artifact in S3 (`s3://models/tenant_123/v1.0/`)

**2.2 Validation & Testing**
- **Split**: 80% training, 20% test
- **Metrics**:
  - Silhouette score (cluster quality)
  - Inertia (within-cluster variance)
  - Davies-Bouldin index
- **Thresholds**:
  - Silhouette > 0.55 (minimum acceptable)
  - Test silhouette within 0.05 of training (consistency)

**2.3 Model Scoring**

**Batch Scoring (SageMaker Batch Transform)**
- **Frequency**: Nightly
- **Input**: S3 Feature Store (all customers)
- **Output**: S3 predictions (`tenant_id, customer_id, cluster_label, confidence`)
- **Instance**: ml.m5.xlarge
- **Time**: ~45 seconds for 10K customers

**Real-time Scoring (SageMaker Endpoint)**
- **Use Case**: On-demand predictions for new customers
- **Instance**: ml.m5.large (auto-scaling 1-5 instances)
- **Latency**: 12ms (p95)
- **API**:
  ```bash
  POST /predict
  {
    "tenant_id": "123",
    "features": {
      "margin_30d": 42.3,
      "purchase_freq": 2.1,
      ...
    }
  }
  ```

**2.4 Model Store**
- **Location**: S3 with versioning enabled
- **Metadata**: DynamoDB table tracking versions, performance, deployment status
- **Rollback**: Keep last 5 versions for instant rollback

---

### 3. Application Layer

**Purpose**: Serve predictions to users via API and UI

#### Components

**3.1 Backend API (Lambda + Node.js)**
- **Framework**: Express.js on AWS Lambda (serverless)
- **Endpoints**:
  - `GET /customers/:tenant_id` - List customers with cluster labels
  - `GET /clusters/:tenant_id/:cluster_id` - Get customers in cluster
  - `GET /insights/:tenant_id` - Business insights and recommendations
  - `POST /predict` - Real-time prediction for new customer
- **Data Source**: Reads S3 JSON outputs from batch scoring
- **Caching**: Redis for frequently accessed data (5-minute TTL)
- **Latency**: 145ms (p95)

**3.2 Frontend (React)**
- **Framework**: React 18 with hooks
- **State Management**: React Context API
- **Data Fetching**: axios with SWR for caching
- **Visualization**:
  - Recharts for charts
  - D3.js for custom visualizations
  - shadcn/ui for components
- **Hosting**: S3 + CloudFront CDN

**3.3 Conversational Interface (Current Implementation)**
- **Type**: Simulated AI using keyword detection
- **Future**: Claude API integration for true NLU
- **Features**:
  - Intent classification
  - Entity extraction
  - Context management
  - Response formatting

---

## Data Pipeline

### End-to-End Flow

```
[PostgreSQL] ──15min──▶ [ETL] ──▶ [S3 Raw]
                                      │
                                      │ Daily
                                      ▼
                              [Feature Engineering]
                                      │
                                      ▼
                               [S3 Feature Store]
                                      │
                          ┌───────────┴───────────┐
                          │                       │
                      Weekly                   Nightly
                          │                       │
                          ▼                       ▼
                    [Model Training]        [Batch Scoring]
                          │                       │
                          ▼                       ▼
                    [Model Store]           [S3 Predictions]
                          │                       │
                          └───────────┬───────────┘
                                      │
                                      ▼
                               [Backend API]
                                      │
                                      ▼
                              [React Frontend]
                                      │
                                      ▼
                                   [User]
```

### Data Guarantees

1. **Exactly-once semantics**: ETL uses timestamp + unique ID to avoid duplicates
2. **Immutability**: S3 objects never modified (only appended)
3. **Versioning**: Models and features are versioned
4. **Audit trail**: CloudWatch logs every operation
5. **Data retention**: Raw data kept 90 days, features kept 1 year

---

## ML Processing

### Feature Engineering Details

#### Windowed Aggregations

```python
# Example: Compute margin over multiple windows
def compute_margin_features(orders_df, customer_id):
    customer_orders = orders_df[orders_df['customer_id'] == customer_id]
    
    features = {}
    for window in [30, 90, 365]:
        cutoff = datetime.now() - timedelta(days=window)
        window_orders = customer_orders[customer_orders['date'] >= cutoff]
        
        features[f'margin_{window}d'] = window_orders['margin'].mean()
        features[f'volume_{window}d'] = window_orders['quantity'].sum()
        features[f'orders_{window}d'] = len(window_orders)
    
    return features
```

#### Normalization

```python
# Per-tenant z-score normalization
def normalize_features(features_df, tenant_id):
    tenant_data = features_df[features_df['tenant_id'] == tenant_id]
    
    for col in numeric_columns:
        mean = tenant_data[col].mean()
        std = tenant_data[col].std()
        features_df.loc[features_df['tenant_id'] == tenant_id, col] = \
            (tenant_data[col] - mean) / std
    
    return features_df
```

### Model Training Process

1. **Data Loading**: Read from S3 Feature Store
2. **Feature Selection**: Choose 8 most important features
3. **Hyperparameter Tuning**: Grid search or Bayesian optimization
4. **Cross-validation**: 5-fold CV to select k (number of clusters)
5. **Final Training**: Train on full dataset with optimal k
6. **Validation**: Compute metrics on holdout set
7. **Model Serialization**: Save with joblib/pickle
8. **Deployment**: Upload to S3 Model Store

### Cluster Interpretation

After training, we assign business-friendly labels to each cluster:

```python
def interpret_cluster(cluster_center, feature_names):
    """
    cluster_center: [0.8, 2.3, 5.0, ...]  (normalized values)
    feature_names: ['margin_30d', 'purchase_freq', ...]
    """
    if cluster_center[0] > 1.0 and cluster_center[1] > 1.0:
        return "Champions"  # High margin, high frequency
    elif cluster_center[0] > 0.5 and cluster_center[1] < 0:
        return "High Potential"  # Good margin, low frequency
    elif cluster_center[2] > 1.5:  # High recency (long time since purchase)
        return "Hibernating"
    elif cluster_center[0] < -0.5:
        return "Unprofitable"  # Low margin
    else:
        return "At Risk"  # Declining metrics
```

---

## Frontend Design

### Component Hierarchy

```
App
├── DataLayer (left sidebar)
│   ├── LayerHeader
│   ├── DataSource × 5
│   │   ├── StatusIndicator
│   │   ├── DataInfo
│   │   └── DataMetrics
├── MLCenter (center column)
│   ├── MLPipeline
│   │   ├── PipelineStages × 5
│   ├── ChatContainer
│   │   ├── ChatHeader
│   │   ├── ChatMessages
│   │   │   └── Message × N
│   │   └── ChatInput
└── AppLayer (right sidebar)
    ├── LayerHeader
    ├── ModelStatus × 3
    └── QuickActions
```

### State Management

Currently using vanilla JS with DOM manipulation:

```javascript
const state = {
    messages: [],
    isProcessing: false,
    activeLayer: 'ml',
    currentTenant: null
};

function updateUI() {
    renderMessages(state.messages);
    updateProcessingIndicator(state.isProcessing);
    // ... more updates
}
```

**Future (React):**
```javascript
const AppContext = React.createContext();

function App() {
    const [messages, setMessages] = useState([]);
    const [isProcessing, setIsProcessing] = useState(false);
    
    return (
        <AppContext.Provider value={{messages, setMessages, ...}}>
            <DataLayer />
            <MLCenter />
            <AppLayer />
        </AppContext.Provider>
    );
}
```

### Responsive Design

- **Desktop (> 1400px)**: 3-column layout (320px | flex | 320px)
- **Laptop (1024-1400px)**: 3-column layout (280px | flex | 280px)
- **Tablet (768-1024px)**: Single column, stacked
- **Mobile (< 768px)**: Single column, collapsible sidebars

---

## Performance Considerations

### Load Time Optimization

1. **Inline everything**: No external requests (except fonts)
2. **Minification**: Remove whitespace and comments for production
3. **Gzip compression**: Enable on web server
4. **CDN**: Serve from CloudFront for global users

### Runtime Performance

1. **Debouncing**: Limit rapid user input
2. **Virtual scrolling**: For large message lists
3. **Lazy rendering**: Render messages as they enter viewport
4. **Memoization**: Cache expensive computations

### Metrics

- **First Contentful Paint**: < 500ms
- **Time to Interactive**: < 800ms
- **Input Latency**: < 50ms (respond to user actions)
- **Frame Rate**: 60 FPS (smooth animations)

---

## Security & Privacy

### Data Protection

1. **Multi-tenancy**: Strict isolation by `tenant_id`
2. **Encryption**: S3 encryption at rest, TLS in transit
3. **Access Control**: IAM roles, least privilege
4. **Audit Logging**: CloudTrail for all API calls

### Frontend Security

1. **XSS Prevention**: Sanitize all user input before rendering
2. **CORS**: Restrict API access to authorized domains
3. **HTTPS Only**: Enforce TLS for all connections
4. **CSP Headers**: Content Security Policy to prevent injection

---

## Future Architecture

### Short-term (3-6 months)

1. **Claude API Integration**: Replace keyword detection with real NLU
2. **Real Data Connection**: Connect to actual PostgreSQL/S3
3. **Live Model Training**: Trigger training from UI
4. **Interactive Charts**: Replace static tables with Recharts/D3

### Long-term (6-12 months)

1. **Additional Models**: Random Forest, XGBoost, Prophet time-series
2. **Multi-model Ensembles**: Combine predictions from multiple models
3. **AutoML**: Automated hyperparameter tuning and model selection
4. **Real-time Streaming**: Kafka + Spark for streaming features
5. **GraphQL API**: Replace REST with GraphQL for flexible queries
6. **Micro-frontends**: Split UI into independent deployable modules

---

## Appendix

### Technology Stack Summary

| Layer | Component | Technology | Purpose |
|-------|-----------|------------|---------|
| Data | Database | PostgreSQL 13 | Source data |
| Data | ETL | Node.js 18 + Lambda | Extract transform load |
| Data | Storage | S3 | Raw data + features |
| Data | Processing | SageMaker Processing | Feature engineering |
| ML | Training | SageMaker Training | Model training |
| ML | Algorithm | scikit-learn K-Means | Clustering |
| ML | Scoring | SageMaker Transform/Endpoint | Batch/real-time |
| App | Backend | Node.js 18 + Express + Lambda | REST API |
| App | Frontend | React 18 | UI framework |
| App | Visualization | Recharts, D3.js | Charts |
| App | Hosting | S3 + CloudFront | Static hosting + CDN |

### References

- [AWS SageMaker Best Practices](https://docs.aws.amazon.com/sagemaker/latest/dg/best-practices.html)
- [MLOps Principles](https://ml-ops.org/)
- [K-Means Clustering (scikit-learn)](https://scikit-learn.org/stable/modules/clustering.html#k-means)
- [React Performance Optimization](https://react.dev/learn/render-and-commit)
