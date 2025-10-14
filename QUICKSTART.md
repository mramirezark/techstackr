# Quick Start Guide

## Prerequisites

- Ruby 3.4.5 or higher
- PostgreSQL running (Docker or local)
- OpenAI API key

## Step-by-Step Setup (3 minutes)

### 1. Install Dependencies

```bash
# From the techstackr directory
bundle config set --local path 'vendor/bundle'
bundle install
```

### 2. Configure Environment

Create a `.env` file in the root directory:

```bash
cat > .env << 'ENVFILE'
# PostgreSQL Connection (update with your credentials)
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_postgres_password

# OpenAI API
OPENAI_API_KEY=sk-your-actual-api-key-here

# Rails Config
RAILS_ENV=development
RAILS_MAX_THREADS=5
ENVFILE
```

**Important:** 
- Replace `your_postgres_password` with your actual PostgreSQL password
- Replace `sk-your-actual-api-key-here` with your OpenAI API key from https://platform.openai.com/api-keys
- If your PostgreSQL is on a different host/port, update `DB_HOST` and `DB_PORT`

### 3. Create Database

```bash
# This creates a new database called techstackr_development
bundle exec rails db:create

# Set up the database schema
bundle exec rails db:migrate
```

### 4. Start the Server

```bash
bundle exec rails server
```

### 5. Open Your Browser

Navigate to: **http://localhost:3000**

## Verify PostgreSQL Connection

If you're unsure about your PostgreSQL connection details:

```bash
# Check if PostgreSQL is accessible
psql -h localhost -U postgres -c "SELECT version();"

# List all databases
psql -h localhost -U postgres -l

# After creating the database, verify it exists
psql -h localhost -U postgres -l | grep techstackr
```

## First Project

1. Click "New Project"
2. Enter:
   - **Title:** "E-commerce Mobile App"
   - **Type:** "Mobile Application"
   - **Description:** "A mobile shopping app for iOS and Android with user authentication, product catalog, shopping cart, payment integration, and order tracking. Expected to handle 10,000 daily active users."
3. Click "Create Project"
4. Click "Generate AI Recommendations"
5. Wait ~10 seconds for results

## Troubleshooting

### "Connection refused" error
```bash
# Check if PostgreSQL is running
# If using Docker:
docker ps | grep postgres

# If not using Docker, check service:
systemctl status postgresql
```

### "password authentication failed"
- Check your `.env` file has the correct password
- Try connecting manually: `psql -h localhost -U postgres`
- Update `DB_PASSWORD` in `.env` with the correct password

### "database does not exist"
```bash
bundle exec rails db:create
```

### "OpenAI API key not configured"
- Make sure you created the `.env` file in the root directory
- Verify your API key is correct
- The `.env` file should not have quotes around the key

### Bundler errors
```bash
bundle config set --local path 'vendor/bundle'
bundle install
```

## Stopping the Application

```bash
# Stop Rails (Ctrl+C in the terminal running rails server)
```

Your PostgreSQL instance will continue running for other projects.

## Database Management

```bash
# Drop the database (removes all data)
bundle exec rails db:drop

# Recreate and migrate
bundle exec rails db:create db:migrate

# Reset database (drop, create, migrate)
bundle exec rails db:reset
```

## Need Help?

See the full [README.md](README.md) for detailed documentation.
