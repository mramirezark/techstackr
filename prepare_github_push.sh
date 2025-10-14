#!/bin/bash
set -e

echo "🔍 Running pre-push checks for TechStackr..."
echo ""

# Security checks
echo "1️⃣  Checking for secrets..."
if git ls-files 2>/dev/null | xargs grep -E "sk-[a-zA-Z0-9]{48}|ghp_[a-zA-Z0-9]{36}" 2>/dev/null; then
    echo "❌ Found potential secrets! Please remove them."
    exit 1
else
    echo "   ✅ No secrets found"
fi

# Check .env files
echo ""
echo "2️⃣  Checking .env files are ignored..."
if git ls-files 2>/dev/null | grep -E "^\.env$" 2>/dev/null; then
    echo "❌ .env file is tracked! Add it to .gitignore"
    exit 1
else
    echo "   ✅ .env files properly ignored"
fi

# Check .env.example exists
echo ""
echo "3️⃣  Checking .env.example exists..."
if [ ! -f .env.example ]; then
    echo "❌ .env.example not found!"
    exit 1
else
    echo "   ✅ .env.example found"
fi

# Code quality
echo ""
echo "4️⃣  Running Rubocop..."
if bundle exec rubocop 2>/dev/null; then
    echo "   ✅ Rubocop passed"
else
    echo "   ⚠️  Rubocop issues found (run 'bundle exec rubocop -A' to auto-fix)"
fi

echo ""
echo "5️⃣  Running Brakeman security scan..."
if bundle exec brakeman --no-pager -q 2>/dev/null; then
    echo "   ✅ Brakeman passed - no security issues"
else
    echo "   ⚠️  Security issues found - review Brakeman output"
fi

echo ""
echo "6️⃣  Running tests..."
if bundle exec rails test 2>/dev/null; then
    echo "   ✅ All tests passed"
else
    echo "   ⚠️  Some tests failed"
fi

# Check documentation
echo ""
echo "7️⃣  Checking documentation files..."
docs=("README.md" "CONTRIBUTING.md" "LICENSE" "SECURITY.md" ".github/pull_request_template.md")
all_docs_exist=true
for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        echo "   ✅ $doc"
    else
        echo "   ❌ $doc missing"
        all_docs_exist=false
    fi
done

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Pre-push checks complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Next steps:"
echo ""
echo "1. Create repository on GitHub: https://github.com/new"
echo "2. Add remote:    git remote add origin <your-repo-url>"
echo "3. Stage files:   git add ."
echo "4. Commit:        git commit -m 'feat: initial commit'"
echo "5. Push:          git push -u origin main"
echo ""
echo "📚 See GITHUB_PUSH_CHECKLIST.md for detailed instructions"
echo ""
