# Contributing to TechStackr

Thank you for your interest in contributing to TechStackr! We welcome contributions from the community.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

## 🤝 Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/techstackr.git
   cd techstackr
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/techstackr.git
   ```

## 💡 How to Contribute

### Reporting Bugs

- Check if the bug has already been reported in [Issues](../../issues)
- If not, create a new issue using the Bug Report template
- Include:
  - Clear description of the bug
  - Steps to reproduce
  - Expected vs actual behavior
  - Environment details (Ruby version, OS, etc.)
  - Screenshots if applicable

### Suggesting Features

- Check if the feature has already been suggested
- Create a new issue using the Feature Request template
- Describe:
  - The problem it solves
  - Proposed solution
  - Alternative solutions considered

### Code Contributions

1. **Find an issue** to work on or create one
2. **Comment** on the issue to let others know you're working on it
3. **Create a branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 🛠️ Development Setup

See [ENV_SETUP.md](ENV_SETUP.md) for detailed setup instructions.

Quick start:
```bash
# Install dependencies
bundle install

# Setup database
cp .env.example .env
# Edit .env with your credentials
bundle exec rails db:create db:migrate

# Run tests
bundle exec rails test

# Start server
bundle exec rails server
```

## 📝 Coding Standards

### Ruby Style Guide

We follow the [Rubocop Rails Omakase](https://github.com/rails/rubocop-rails-omakase) style guide.

```bash
# Check your code
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -A
```

### Best Practices

- Write clear, self-documenting code
- Add comments for complex logic
- Follow Rails conventions and patterns
- Keep methods small and focused (< 10 lines preferred)
- Use descriptive variable and method names
- Avoid hardcoding values - use constants or config

### Testing

- Write tests for new features
- Update tests when modifying existing code
- Maintain or improve test coverage
- Run the full test suite before submitting PR

```bash
# Run all tests
bundle exec rails test

# Run specific test file
bundle exec rails test test/models/project_test.rb

# Run system tests
bundle exec rails test:system
```

### Database Migrations

- Use descriptive migration names
- Make migrations reversible when possible
- Test both `up` and `down` migrations
- Never modify existing migrations that have been merged
- Check migration metadata:
  ```bash
  bundle exec rails db:migrate:info
  ```

## 📤 Commit Guidelines

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```bash
git commit -m "feat(recommendations): add technology filtering"
git commit -m "fix(migrations): resolve migration metadata tracking"
git commit -m "docs(readme): update setup instructions"
```

### Commit Best Practices

- Keep commits atomic (one logical change per commit)
- Write clear, descriptive commit messages
- Reference issues when applicable: `fixes #123`

## 🔄 Pull Request Process

### Before Submitting

1. **Update from main**:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run checks**:
   ```bash
   bundle exec rubocop
   bundle exec rails test
   bundle exec brakeman --no-pager
   ```

3. **Update documentation** if needed

### Submitting PR

1. **Push your branch**:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request** on GitHub:
   - Use a clear, descriptive title
   - Fill out the PR template completely
   - Link related issues
   - Add screenshots/GIFs for UI changes
   - Request review from maintainers

3. **Address feedback**:
   - Respond to review comments
   - Make requested changes
   - Push updates to your branch

### PR Requirements

- ✅ All tests pass
- ✅ Code follows style guide (Rubocop passes)
- ✅ No security vulnerabilities (Brakeman passes)
- ✅ Documentation updated
- ✅ Commit messages follow guidelines
- ✅ Branch is up to date with `main`

## 🏗️ Project Structure

```
techstackr/
├── app/
│   ├── controllers/      # Request handling
│   ├── models/           # Data models
│   ├── services/         # Business logic
│   └── views/            # Templates
├── config/               # Configuration
├── db/
│   └── migrate/          # Database migrations
├── lib/
│   └── tasks/            # Rake tasks
└── test/                 # Tests
```

## 🔍 Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [Ruby Style Guide](https://rubystyle.guide/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [OpenAI API Docs](https://platform.openai.com/docs/)

## ❓ Questions?

- Open a [Discussion](../../discussions) for general questions
- Join our community chat (if applicable)
- Tag maintainers in issues/PRs

## 🙏 Thank You!

Your contributions make TechStackr better for everyone. We appreciate your time and effort!

