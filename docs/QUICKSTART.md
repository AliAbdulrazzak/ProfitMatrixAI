# Quick Start Guide

Get up and running with ProfitMatrix ML Agent in less than 5 minutes!

## Prerequisites

- Modern web browser (Chrome 90+, Firefox 88+, Safari 14+, or Edge 90+)
- No other dependencies required!

## Option 1: Download and Open (Fastest)

1. **Download the file**
   ```bash
   curl -O https://raw.githubusercontent.com/crashing-out/profitmatrix-ml-agent/main/src/index.html
   ```

2. **Open in browser**
   - Double-click `index.html`, or
   - Drag it into your browser window

3. **Start exploring!**
   - Click any quick action button on the right
   - Or type a question in the chat

## Option 2: Clone Repository

1. **Clone the repo**
   ```bash
   git clone https://github.com/crashing-out/profitmatrix-ml-agent.git
   cd profitmatrix-ml-agent
   ```

2. **Open the app**
   ```bash
   open src/index.html
   # or on Linux
   xdg-open src/index.html
   # or on Windows
   start src/index.html
   ```

## Option 3: Run with HTTP Server

For a more production-like setup:

### Using Python (recommended)
```bash
# Navigate to the project directory
cd profitmatrix-ml-agent

# Start server
python3 -m http.server 8000

# Open in browser
open http://localhost:8000/src/index.html
```

### Using Node.js
```bash
# Install http-server globally (one-time)
npm install -g http-server

# Start server
http-server -p 8000

# Open in browser
open http://localhost:8000/src/index.html
```

### Using PHP
```bash
php -S localhost:8000
# Then navigate to http://localhost:8000/src/index.html
```

## First Steps

Once the app is open:

### 1. Explore the Interface

- **Left sidebar (Data Layer)**: Shows data pipeline status
- **Center (ML Layer)**: Pipeline visualization and chat interface
- **Right sidebar (App Layer)**: Model metrics and quick actions

### 2. Try Quick Actions

Click any button on the right sidebar:
- 🎯 **Run K-Means Clustering** - See customer segmentation
- 📊 **Show Feature Store** - Learn about feature engineering
- 🔄 **Explain Pipeline Flow** - Understand the architecture
- 🏗️ **System Architecture** - Deep dive into components
- ⚡ **Model Performance** - View quality metrics

### 3. Ask Questions

Type in the chat input at the bottom:
- "Run customer clustering"
- "Show me the feature engineering process"
- "Explain the complete ML pipeline"
- "What are the model performance metrics?"

## Example Conversation

```
You: Run K-Means clustering on all customers

ML Agent: 🎯 K-Means Customer Clustering Results

[Shows detailed execution flow, cluster assignments, and business insights]

You: Which cluster has the highest margins?

ML Agent: [Explains Champions cluster with 48.3% margins]

You: How do I improve margins for the unprofitable segment?

ML Agent: [Provides specific recommendations]
```

## Understanding the Output

### Cluster Results
- **Champions** (6%): Protect with VIP treatment
- **High Potential** (12%): Grow volume opportunities
- **At Risk** (22%): Retention campaigns needed
- **Hibernating** (29%): Win-back strategies
- **Unprofitable** (30%): Reprice or exit

### Feature Importance
The ML model uses 8 primary features:
1. margin_30d (34% importance)
2. purchase_freq (28%)
3. recency_days (19%)
4. volume_agg (9%)
5. Others (10%)

### Quality Metrics
- **Silhouette Score**: 0.67 (good separation)
- **Training Time**: 23.4 seconds
- **Inference**: 12ms per customer

## Troubleshooting

### Page Not Loading
- **Check browser version**: Must be modern (2021+)
- **Disable ad blockers**: May interfere with fonts
- **Try incognito mode**: Rules out extension conflicts

### Blank Screen
- **Check console**: Press F12 → Console tab
- **JavaScript enabled**: Must be on for app to work
- **CORS issues**: Use HTTP server, not file:// protocol

### Styling Issues
- **Fonts not loading**: Check internet connection (Google Fonts)
- **Layout broken**: Try zooming to 100% (Ctrl+0 or Cmd+0)
- **Responsive issues**: Refresh page after resizing

### Performance Issues
- **Slow loading**: Check network tab (F12 → Network)
- **Laggy animations**: Try closing other browser tabs
- **High memory**: Refresh page to clear message history

## Advanced Usage

### Embedding in Your App
```html
<iframe 
  src="https://your-domain.com/profitmatrix-ml-agent/" 
  width="100%" 
  height="100%" 
  frameborder="0"
></iframe>
```

### Customizing Colors
Edit the `:root` CSS variables:
```css
:root {
  --bg-primary: #0A0E1A;
  --accent-ml: #C47474;
  /* ... more variables */
}
```

### Adding New Responses
Modify the `getMLResponse()` function:
```javascript
if (lowerMessage.includes('your-trigger')) {
  return `<p>Your custom response HTML</p>`;
}
```

## Next Steps

- ⭐ **Star the repo** if you find it useful
- 📝 **Read the full documentation** in [README.md](README.md)
- 🏗️ **Explore the architecture** in [ARCHITECTURE.md](docs/ARCHITECTURE.md)
- 🤝 **Contribute** using [CONTRIBUTING.md](CONTRIBUTING.md)
- 🐛 **Report issues** on [GitHub Issues](https://github.com/crashing-out/profitmatrix-ml-agent/issues)

## Getting Help

- **Documentation**: Check README and ARCHITECTURE docs
- **Examples**: See [examples/](examples/) directory
- **Issues**: Search or create on GitHub
- **Discussions**: Use GitHub Discussions for questions

## What's Next?

After getting familiar with the interface, you might want to:

1. **Integrate with real data** - Connect to your PostgreSQL database
2. **Add Claude API** - Enable true conversational AI
3. **Create visualizations** - Add interactive charts
4. **Deploy to production** - Host on AWS S3 + CloudFront
5. **Customize for your needs** - Modify features and styling

Happy exploring! 🚀
