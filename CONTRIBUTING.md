# Contributing to ProfitMatrix ML Agent

First off, thank you for considering contributing to ProfitMatrix ML Agent! It's people like you that make this tool better for everyone.

## Code of Conduct

This project and everyone participating in it is governed by our commitment to fostering an open and welcoming environment. Please be respectful and constructive in your interactions.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** (screenshots, code snippets)
- **Describe the behavior you observed** and what you expected
- **Include browser and OS information**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description** of the suggested enhancement
- **Explain why this enhancement would be useful**
- **List any alternatives you've considered**

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following our coding standards
3. **Test thoroughly** on multiple browsers
4. **Update documentation** if needed
5. **Write a clear commit message** describing your changes
6. **Submit a pull request** with a comprehensive description

## Development Guidelines

### Architecture Principles

- **Single-file design**: Keep everything in one HTML file (no build process)
- **Zero dependencies**: No npm packages, no external libraries
- **Progressive enhancement**: Work without JavaScript (where possible)
- **Accessibility first**: Follow WCAG guidelines

### Code Style

#### HTML
- Use semantic HTML5 elements
- Indent with 2 spaces
- Add comments for complex sections
- Use lowercase for tags and attributes

#### CSS
- Use CSS variables for theming
- Organize by component
- Mobile-first responsive design
- Add comments for non-obvious styles
- Indent with 2 spaces

```css
/* Good */
.component {
  display: flex;
  gap: 12px; /* Consistent spacing unit */
}

/* Avoid */
.component{display:flex;gap:12px;}
```

#### JavaScript
- Use ES6+ features (const/let, arrow functions, async/await)
- Indent with 2 spaces
- Use meaningful variable names
- Add comments for complex logic
- Handle errors gracefully

```javascript
// Good
async function fetchData() {
  try {
    const response = await getMLResponse(query);
    return response;
  } catch (error) {
    console.error('Error fetching data:', error);
    return null;
  }
}

// Avoid
function fetchData(){return getMLResponse(query)}
```

### Testing Checklist

Before submitting a PR, test on:
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)
- [ ] Mobile Chrome (Android)
- [ ] Mobile Safari (iOS)

Test these scenarios:
- [ ] Load page from file:// protocol
- [ ] Load page from HTTP server
- [ ] Send various types of messages
- [ ] Click all quick action buttons
- [ ] Resize window (responsive behavior)
- [ ] Test keyboard navigation
- [ ] Verify accessibility with screen reader

### Commit Messages

Use the following format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(chat): add support for markdown formatting in responses

Added markdown parsing to chat messages, allowing bold, italic,
and code formatting in AI responses.

Closes #123
```

```
fix(ui): correct alignment issue in mobile view

Fixed flexbox alignment causing buttons to overflow on screens
smaller than 768px.
```

## Areas for Contribution

We especially welcome contributions in these areas:

### High Priority
- [ ] Claude API integration for real AI responses
- [ ] Interactive charts and visualizations
- [ ] Export functionality (PDF, Excel)
- [ ] Dark/light theme toggle
- [ ] Keyboard shortcuts

### Medium Priority
- [ ] Additional ML model explanations (Random Forest, XGBoost)
- [ ] More example queries and responses
- [ ] Animation improvements
- [ ] Accessibility enhancements
- [ ] Multi-language support

### Low Priority
- [ ] Custom color themes
- [ ] Sound effects for interactions
- [ ] Advanced typography options
- [ ] Print stylesheet
- [ ] Offline mode with Service Worker

## Documentation

When adding new features, please update:
- `README.md` - High-level overview and usage
- Code comments - Inline documentation
- `CHANGELOG.md` - List of changes (if we add this)

## Questions?

Feel free to open an issue with the `question` label, or reach out to the team:
- Ali Abdulrazzak
- Alex DiMichele
- Chris Ross
- Sebastian Tran
- Logan Yates

## Recognition

Contributors will be recognized in:
- `README.md` acknowledgments section
- Release notes
- Project website (if/when created)

Thank you for contributing! 🎉
