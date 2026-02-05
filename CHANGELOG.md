# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Claude API integration for true conversational AI
- Real PostgreSQL/S3 data connection
- Interactive visualizations with Chart.js/D3.js
- Export functionality (PDF, Excel, PowerPoint)
- Dark/light theme toggle
- Multi-language support

## [1.0.0] - 2026-02-01

### Added
- Initial release of ProfitMatrix ML Agent
- 3-layer architecture visualization (Data, ML, Application layers)
- Conversational AI interface with keyword-based intent detection
- ML pipeline status display with 5 stages
- Customer clustering explanation (K-Means with 5 segments)
- Feature engineering documentation (43 features)
- Complete architecture walkthrough
- Model performance metrics display
- Quick action buttons for common queries
- Real-time metrics dashboard
- Responsive 3-column layout
- Zero-dependency implementation (single HTML file)
- Comprehensive documentation (README, ARCHITECTURE, CONTRIBUTING)
- MIT License
- GitHub repository structure

### Features by Layer

#### Data Layer (Left Sidebar)
- RDS PostgreSQL status and metrics
- ETL pipeline job information
- S3 Raw Data Bucket statistics
- Feature Engineering processing stats
- S3 Feature Store overview

#### ML Layer (Center)
- Pipeline visualization with animated progress bars
- Chat interface for ML exploration
- Detailed responses for:
  - Customer clustering results
  - Feature store explanation
  - Pipeline architecture details
  - Model performance metrics
- Message history with formatted tables and insights
- Processing indicators

#### Application Layer (Right Sidebar)
- Backend API metrics (Node.js/Lambda)
- Frontend framework information (React)
- ML model performance dashboard
- Quick action buttons (5 common queries)

### Technical Details
- **File Size**: ~65 KB (uncompressed)
- **Load Time**: < 1 second
- **Browser Support**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- **Mobile Support**: Fully responsive design
- **Accessibility**: WCAG-compliant color contrast, keyboard navigation

### Documentation
- Comprehensive README with quickstart, examples, and use cases
- Detailed ARCHITECTURE.md explaining system design
- CONTRIBUTING.md with development guidelines
- LICENSE (MIT)
- Package.json for npm compatibility

## [0.1.0] - 2026-01-25

### Added
- Initial prototype with basic chat interface
- Proof of concept for ML pipeline visualization
- Early architecture design

---

## Version History Summary

- **1.0.0** (2026-02-01): First public release with complete feature set
- **0.1.0** (2026-01-25): Internal prototype and POC

---

## Links

- [Repository](https://github.com/crashing-out/profitmatrix-ml-agent)
- [Issues](https://github.com/crashing-out/profitmatrix-ml-agent/issues)
- [Pull Requests](https://github.com/crashing-out/profitmatrix-ml-agent/pulls)
