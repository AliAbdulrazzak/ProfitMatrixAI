#!/bin/bash
# GitHub Repository Setup Script for ProfitMatrix ML Agent
# This script helps you quickly set up and push to GitHub

set -e  # Exit on error

echo "======================================"
echo "ProfitMatrix ML Agent - GitHub Setup"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Git is not installed. Please install git first.${NC}"
    exit 1
fi

echo -e "${BLUE}Step 1: Repository Information${NC}"
echo "Enter your GitHub username:"
read -r GITHUB_USERNAME

echo "Enter repository name (default: profitmatrix-ml-agent):"
read -r REPO_NAME
REPO_NAME=${REPO_NAME:-profitmatrix-ml-agent}

echo ""
echo -e "${BLUE}Step 2: Initialize Git Repository${NC}"

# Initialize git if not already initialized
if [ ! -d .git ]; then
    git init
    echo -e "${GREEN}✓ Git repository initialized${NC}"
else
    echo -e "${YELLOW}⚠ Git repository already exists${NC}"
fi

echo ""
echo -e "${BLUE}Step 3: Configure Git${NC}"
echo "Enter your name for git commits:"
read -r GIT_NAME

echo "Enter your email for git commits:"
read -r GIT_EMAIL

git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"
echo -e "${GREEN}✓ Git configured${NC}"

echo ""
echo -e "${BLUE}Step 4: Add Files to Git${NC}"
git add .
echo -e "${GREEN}✓ Files added to staging${NC}"

echo ""
echo -e "${BLUE}Step 5: Create Initial Commit${NC}"
git commit -m "Initial commit: ProfitMatrix ML Agent v1.0.0

- Complete ML pipeline visualization
- Conversational AI interface
- 3-layer architecture (Data, ML, Application)
- Comprehensive documentation
- Zero dependencies implementation
"
echo -e "${GREEN}✓ Initial commit created${NC}"

echo ""
echo -e "${BLUE}Step 6: Set Remote Repository${NC}"
git remote add origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
echo -e "${GREEN}✓ Remote repository set${NC}"

echo ""
echo -e "${BLUE}Step 7: Create Main Branch${NC}"
git branch -M main
echo -e "${GREEN}✓ Main branch created${NC}"

echo ""
echo "======================================"
echo -e "${GREEN}Setup Complete!${NC}"
echo "======================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Create a new repository on GitHub:"
echo -e "   ${BLUE}https://github.com/new${NC}"
echo -e "   Repository name: ${YELLOW}${REPO_NAME}${NC}"
echo "   Description: AI-powered conversational interface for manufacturing pricing intelligence"
echo "   Public/Private: Your choice"
echo "   DO NOT initialize with README, .gitignore, or license"
echo ""
echo "2. After creating the repository, run:"
echo -e "   ${YELLOW}git push -u origin main${NC}"
echo ""
echo "3. Your repository will be available at:"
echo -e "   ${BLUE}https://github.com/${GITHUB_USERNAME}/${REPO_NAME}${NC}"
echo ""
echo "Optional: Set up GitHub Pages"
echo "   - Go to repository Settings → Pages"
echo "   - Source: Deploy from branch 'main', folder '/src'"
echo -e "   - Your app will be live at: ${BLUE}https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/${NC}"
echo ""
echo "======================================"
