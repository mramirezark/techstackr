# Security Policy

## 🔒 Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## 🐛 Reporting a Vulnerability

We take the security of TechStackr seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### How to Report

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report them via one of the following methods:

1. **Email**: Send details to [security@techstackr.com] (or your security email)
2. **GitHub Security Advisory**: Use GitHub's [Security Advisories](../../security/advisories/new) feature (preferred)

### What to Include

Please include the following information in your report:

- Type of vulnerability (e.g., SQL injection, XSS, authentication bypass)
- Full paths of source file(s) related to the vulnerability
- Location of the affected source code (tag/branch/commit or direct URL)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

### What to Expect

- **Initial Response**: Within 48 hours
- **Assessment**: We'll investigate and assess the severity within 5 business days
- **Updates**: We'll keep you informed about the progress
- **Fix**: We'll work on a fix and coordinate the release with you
- **Credit**: We'll acknowledge your contribution in the security advisory (unless you prefer to remain anonymous)

## 🛡️ Security Best Practices

### For Users

1. **Environment Variables**: Never commit `.env` files or expose API keys
2. **Database Credentials**: Use strong passwords and rotate them regularly
3. **API Keys**: Restrict OpenAI API key permissions to only what's needed
4. **HTTPS**: Always use HTTPS in production
5. **Updates**: Keep Ruby, Rails, and all gems up to date

### For Contributors

1. **Dependencies**: Run `bundle audit` to check for vulnerable dependencies
2. **Static Analysis**: Run `bundle exec brakeman` before submitting PRs
3. **Input Validation**: Always validate and sanitize user input
4. **SQL Injection**: Use parameterized queries (ActiveRecord handles this)
5. **XSS Protection**: Escape output in views (ERB handles this by default)
6. **Authentication**: Use Rails' built-in CSRF protection
7. **Secrets**: Never hardcode secrets, use Rails credentials or environment variables

## 🔍 Security Checks

Before deploying or contributing, run these security checks:

```bash
# Check for vulnerable dependencies
bundle audit

# Static security analysis
bundle exec brakeman --no-pager

# Check for hardcoded secrets (if you have gitleaks installed)
gitleaks detect --source . --verbose

# Audit JavaScript dependencies  
bin/importmap audit
```

## 🔐 Recommended Security Headers

Ensure these headers are set in production:

```ruby
# config/application.rb or config/environments/production.rb
config.force_ssl = true
config.action_dispatch.default_headers.merge!({
  'X-Frame-Options' => 'SAMEORIGIN',
  'X-Content-Type-Options' => 'nosniff',
  'X-XSS-Protection' => '1; mode=block',
  'Referrer-Policy' => 'strict-origin-when-cross-origin'
})
```

## 🚨 Known Security Considerations

### API Key Management

- OpenAI API keys should be restricted to specific IP addresses in production
- Use environment variables, never commit API keys
- Rotate API keys regularly

### Database Security

- Use SSL connections to PostgreSQL in production
- Implement Row Level Security (RLS) if using Supabase
- Regular database backups

### Rate Limiting

- Consider implementing rate limiting for AI API calls
- Prevent abuse of the recommendation generation endpoint

## 📚 Security Resources

- [Rails Security Guide](https://guides.rubyonrails.org/security.html)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Ruby Security Best Practices](https://github.com/rubysec/ruby-advisory-db)
- [Brakeman Documentation](https://brakemanscanner.org/docs/)

## 🏆 Security Hall of Fame

We'd like to thank the following people for responsibly disclosing security issues:

<!-- Names will be added here as vulnerabilities are reported and fixed -->

---

**Note**: This security policy is subject to change. Please check back regularly for updates.

