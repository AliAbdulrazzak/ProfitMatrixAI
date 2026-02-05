# GitHub Deployment Guide

Complete step-by-step instructions to get ProfitMatrix ML Agent on GitHub.

## Quick Deploy (Automated)

### Option 1: Using the Setup Script (Recommended)

```bash
# 1. Navigate to the repository directory
cd profitmatrix-ml-agent

# 2. Run the setup script
./setup-github.sh

# 3. Follow the prompts to configure git and remote

# 4. Create repository on GitHub.com (instructions will be shown)

# 5. Push to GitHub
git push -u origin main
```

## Manual Deploy (Step-by-Step)

### Prerequisites

- Git installed on your computer
- GitHub account created
- Terminal/Command Prompt access

### Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Fill in repository details:
   - **Repository name**: `profitmatrix-ml-agent`
   - **Description**: `AI-powered conversational interface for manufacturing pricing intelligence`
   - **Visibility**: Public (or Private if you prefer)
   - **DO NOT** check "Initialize this repository with:"
     - ❌ Add a README file
     - ❌ Add .gitignore
     - ❌ Choose a license
3. Click "Create repository"

### Step 2: Initialize Local Repository

Open terminal and navigate to the project directory:

```bash
cd profitmatrix-ml-agent
```

Initialize git (if not already done):

```bash
git init
```

### Step 3: Configure Git

Set your name and email:

```bash
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### Step 4: Add Files

Add all files to git:

```bash
git add .
```

Check what will be committed:

```bash
git status
```

You should see all files in green, ready to commit.

### Step 5: Create Initial Commit

```bash
git commit -m "Initial commit: ProfitMatrix ML Agent v1.0.0

- Complete ML pipeline visualization
- Conversational AI interface  
- 3-layer architecture implementation
- Comprehensive documentation
- Zero dependencies"
```

### Step 6: Add Remote Repository

Replace `YOUR_USERNAME` with your GitHub username:

```bash
git remote add origin https://github.com/YOUR_USERNAME/profitmatrix-ml-agent.git
```

Verify the remote was added:

```bash
git remote -v
```

### Step 7: Create Main Branch

```bash
git branch -M main
```

### Step 8: Push to GitHub

```bash
git push -u origin main
```

If prompted for credentials:
- **Username**: Your GitHub username
- **Password**: Use a Personal Access Token (not your GitHub password)
  - Create token at: https://github.com/settings/tokens
  - Select scopes: `repo` (full control of private repositories)

### Step 9: Verify Upload

Go to your repository URL:
```
https://github.com/YOUR_USERNAME/profitmatrix-ml-agent
```

You should see all files and folders!

## Enable GitHub Pages (Optional)

Host your application for free on GitHub Pages:

### Step 1: Go to Repository Settings

1. Click "Settings" tab in your repository
2. Scroll down to "Pages" in the left sidebar

### Step 2: Configure Source

1. Under "Build and deployment"
2. Source: **Deploy from a branch**
3. Branch: **main**
4. Folder: **/src** or **/ (root)**
5. Click "Save"

### Step 3: Wait for Deployment

- GitHub will build and deploy (takes 1-2 minutes)
- Check the green checkmark in Actions tab
- Your site will be live at: `https://YOUR_USERNAME.github.io/profitmatrix-ml-agent/`

### Step 4: Update README (Optional)

Add a live demo link to your README.md:

```markdown
## 🚀 Live Demo

Try it now: [https://YOUR_USERNAME.github.io/profitmatrix-ml-agent/](https://YOUR_USERNAME.github.io/profitmatrix-ml-agent/)
```

Commit and push:

```bash
git add README.md
git commit -m "docs: add live demo link"
git push
```

## Troubleshooting

### Error: "remote origin already exists"

Solution:
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/profitmatrix-ml-agent.git
```

### Error: "failed to push some refs"

Solution:
```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

### Error: "Authentication failed"

Solution:
1. Create Personal Access Token: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes: `repo`
4. Copy the token
5. Use token as password when prompted

### GitHub Pages Not Working

1. Check Settings → Pages → Source is set correctly
2. Verify files are in the correct directory
3. Check Actions tab for build errors
4. Try accessing: `https://YOUR_USERNAME.github.io/profitmatrix-ml-agent/src/index.html`

### Files Not Appearing

1. Check `.gitignore` - files might be excluded
2. Run `git status` to see untracked files
3. Use `git add -f <file>` to force-add ignored files

## Advanced: SSH Authentication

For easier pushing without passwords:

### Step 1: Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
# Press Enter to accept defaults
```

### Step 2: Add to GitHub

```bash
# Copy your public key
cat ~/.ssh/id_ed25519.pub
# Copy the output
```

1. Go to https://github.com/settings/keys
2. Click "New SSH key"
3. Paste your public key
4. Click "Add SSH key"

### Step 3: Change Remote to SSH

```bash
git remote set-url origin git@github.com:YOUR_USERNAME/profitmatrix-ml-agent.git
```

Now you can push without entering credentials!

## Repository Management

### Create a New Branch

```bash
git checkout -b feature/new-feature
# Make changes
git add .
git commit -m "feat: add new feature"
git push -u origin feature/new-feature
```

### Create Pull Request

1. Go to repository on GitHub
2. Click "Pull requests" → "New pull request"
3. Select your branch
4. Click "Create pull request"
5. Add description
6. Click "Create pull request"

### Merge Pull Request

1. Review changes
2. Click "Merge pull request"
3. Click "Confirm merge"
4. Delete branch (optional)

### Update Local Repository

```bash
git pull origin main
```

## Collaborators

### Add Collaborators

1. Go to Settings → Collaborators
2. Click "Add people"
3. Enter GitHub username or email
4. Select permission level
5. Click "Add [username] to this repository"

### Clone Repository (for collaborators)

```bash
git clone https://github.com/YOUR_USERNAME/profitmatrix-ml-agent.git
cd profitmatrix-ml-agent
```

## Continuous Integration

The repository includes GitHub Actions CI/CD:

### View Build Status

1. Go to "Actions" tab
2. See all workflow runs
3. Click a run to see details

### Badges

Add build status badge to README:

```markdown
[![CI/CD](https://github.com/YOUR_USERNAME/profitmatrix-ml-agent/workflows/CI%2FCD%20Pipeline/badge.svg)](https://github.com/YOUR_USERNAME/profitmatrix-ml-agent/actions)
```

## Release Management

### Create a Release

1. Go to "Releases" → "Create a new release"
2. Click "Choose a tag" → type `v1.0.0` → "Create new tag"
3. Release title: `Release v1.0.0`
4. Description: Copy from CHANGELOG.md
5. Attach `src/index.html` as binary
6. Click "Publish release"

### Automatic Releases

The CI/CD pipeline creates releases automatically when you push to main with a new version in package.json.

## Repository Settings

### Recommended Settings

1. **Options**:
   - ✅ Issues
   - ✅ Projects  
   - ✅ Discussions
   - ✅ Wiki

2. **Branches**:
   - Add branch protection rule for `main`
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass

3. **Secrets**:
   - Add any API keys or secrets
   - Go to Settings → Secrets and variables → Actions

## Support

If you encounter issues:

1. Check this guide thoroughly
2. Search GitHub Issues: https://github.com/YOUR_USERNAME/profitmatrix-ml-agent/issues
3. Create new issue if needed
4. Check GitHub's official docs: https://docs.github.com

## Next Steps

After deploying to GitHub:

1. ⭐ **Add topics** to repository (Settings → About → Topics):
   - `machine-learning`
   - `artificial-intelligence`
   - `pricing`
   - `manufacturing`
   - `customer-segmentation`
   - `conversational-ai`

2. 📝 **Create GitHub Wiki**:
   - Add tutorials
   - Add API documentation
   - Add troubleshooting guides

3. 💬 **Enable Discussions**:
   - Q&A section
   - Show and tell
   - Ideas and feature requests

4. 📊 **Add badges to README**:
   - Build status
   - License
   - Version
   - Downloads

5. 🌟 **Promote your project**:
   - Share on LinkedIn
   - Post on Reddit (r/MachineLearning, r/webdev)
   - Tweet about it
   - Write a blog post

Congratulations! Your ProfitMatrix ML Agent is now on GitHub! 🎉
