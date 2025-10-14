# PostgreSQL Setup Guide

## You Already Have PostgreSQL! ✅

This guide helps you connect TechStackr to your existing PostgreSQL instance.

## Quick Steps

### 1. Find Your PostgreSQL Credentials

#### If using Docker:
```bash
# Check running containers
docker ps | grep postgres

# View container details
docker inspect <container_id> | grep -E "POSTGRES_USER|POSTGRES_PASSWORD"

# Or check your docker run command / docker-compose.yml
```

#### If using local PostgreSQL:
```bash
# Check if running
systemctl status postgresql

# Find the port
sudo netstat -plnt | grep postgres

# Or
psql -h localhost -U postgres -c "SHOW port;"
```

### 2. Test Connection

```bash
# Try connecting
psql -h localhost -U postgres -c "SELECT version();"

# If successful, you'll see PostgreSQL version info
```

### 3. Create .env File

Create `.env` in the root directory:

```bash
cat > .env << 'ENVFILE'
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_actual_password
OPENAI_API_KEY=sk-your-key-here
RAILS_ENV=development
RAILS_MAX_THREADS=5
ENVFILE
```

Update with your actual credentials!

### 4. Create Database

```bash
# This creates techstackr_development in your PostgreSQL
bundle exec rails db:create

# Set up the schema
bundle exec rails db:migrate
```

### 5. Verify

```bash
# List databases
psql -h localhost -U postgres -l | grep techstackr

# You should see:
# techstackr_development
```

## Common Scenarios

### Docker PostgreSQL (Most Common)

**Default Docker setup:**
```env
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
```

**Custom Docker setup:**
Check your `docker run` command or `docker-compose.yml`:
```bash
docker run -e POSTGRES_PASSWORD=mypassword postgres
                              ↑
                    Use this in .env
```

### Local PostgreSQL

**Ubuntu/Debian:**
```bash
# Default user is usually 'postgres'
# May need to set password first
sudo -u postgres psql
ALTER USER postgres PASSWORD 'newpassword';
\q
```

**macOS (Homebrew):**
```bash
# Usually no password by default
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=your_username
DB_PASSWORD=
```

### Remote PostgreSQL

```env
DB_HOST=db.example.com
DB_PORT=5432
DB_USERNAME=myuser
DB_PASSWORD=mypassword
```

## Troubleshooting

### Can't Connect

**Error: "Connection refused"**
```bash
# Check if PostgreSQL is running
docker ps | grep postgres
# or
systemctl status postgresql
```

**Error: "password authentication failed"**
```bash
# Test your credentials
psql -h localhost -U postgres
# If this fails, your password is wrong
```

**Error: "could not connect to server"**
```bash
# Check the port
DB_PORT=5432  # try default
# or
DB_PORT=5433  # some setups use this
```

### Finding Your PostgreSQL Port

```bash
# Method 1: netstat
sudo netstat -plnt | grep postgres

# Method 2: Docker
docker port <container_name>

# Method 3: PostgreSQL config
psql -h localhost -U postgres -c "SHOW port;"
```

### Database Already Exists

If you see "database already exists":
```bash
# Drop and recreate
bundle exec rails db:drop db:create db:migrate

# Or just run migrations
bundle exec rails db:migrate
```

## Database Management

```bash
# Create database
bundle exec rails db:create

# Run migrations
bundle exec rails db:migrate

# Drop database (removes all data!)
bundle exec rails db:drop

# Reset (drop + create + migrate)
bundle exec rails db:reset

# View database in PostgreSQL
psql -h localhost -U postgres -d techstackr_development
```

## Security Notes

- Don't commit `.env` to version control (it's in .gitignore)
- Use strong passwords in production
- Consider restricting PostgreSQL to localhost if not needed remotely
- Keep PostgreSQL updated

## Need More Help?

- PostgreSQL Documentation: https://www.postgresql.org/docs/
- Rails Database Guide: https://guides.rubyonrails.org/active_record_basics.html
- Check `log/development.log` for Rails database errors
