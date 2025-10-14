# Environment Setup Instructions

## Required Configuration

You need two things:
1. **PostgreSQL credentials** (you already have PostgreSQL running!)
2. **OpenAI API key**

## Setting Up Your .env File

Create a file named `.env` in the **root directory** with your configuration:

```env
# PostgreSQL Connection
# Update these to match your PostgreSQL setup
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_actual_postgres_password

# OpenAI API Configuration
OPENAI_API_KEY=sk-your-actual-api-key-here

# Rails Configuration
RAILS_ENV=development
RAILS_MAX_THREADS=5
```

## Getting Your PostgreSQL Credentials

### If you're using Docker PostgreSQL:

```bash
# Check your running PostgreSQL container
docker ps | grep postgres

# Check environment variables
docker inspect <container_id> | grep -A 20 Env
```

Common Docker PostgreSQL defaults:
- Host: `localhost`
- Port: `5432`
- Username: `postgres`
- Password: Check your docker run command or docker-compose

### If you're using local PostgreSQL:

```bash
# Check if PostgreSQL is running
systemctl status postgresql

# Test connection
psql -h localhost -U postgres -c "SELECT version();"
```

### Finding Your Port:

```bash
# Check which port PostgreSQL is running on
sudo netstat -plnt | grep postgres

# Or check PostgreSQL config
psql -h localhost -U postgres -c "SHOW port;"
```

## Getting Your OpenAI API Key

1. Go to https://platform.openai.com/api-keys
2. Sign up or log in
3. Click "Create new secret key"
4. Copy the key (starts with `sk-`)

## Creating the .env File

### Option 1: Manual Creation

```bash
# Create the file
nano .env

# Or use your favorite editor
vim .env
code .env
```

### Option 2: Command Line

```bash
cat > .env << 'ENVFILE'
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_password_here
OPENAI_API_KEY=sk-your-key-here
RAILS_ENV=development
RAILS_MAX_THREADS=5
ENVFILE
```

Then edit the file to add your actual credentials.

## Important Notes

- **Do NOT add quotes** around the values
- **Do NOT commit** the `.env` file to git (it's already in .gitignore)
- The `.env` file must be in the **root directory**
- Replace placeholder values with your actual credentials

## Verifying Your Setup

### 1. Check the .env file exists:
```bash
ls -la .env
```

### 2. Verify PostgreSQL connection:
```bash
psql -h localhost -U postgres -c "SELECT 1;"
```

If this works, your PostgreSQL credentials are correct!

### 3. Test the Rails connection:
```bash
bundle exec rails db:create
```

If you see "Created database 'techstackr_development'", you're all set!

## Testing the Configuration

Start your Rails server and try creating a project:

```bash
bundle exec rails server
```

Visit http://localhost:3000 and create a project.

### If you see errors:

**"OpenAI API key not configured"**
1. Check that `.env` exists in the root directory
2. Verify the API key has no quotes
3. Restart the Rails server
4. Make sure you have credits in your OpenAI account

**"Connection refused" or "password authentication failed"**
1. Verify PostgreSQL is running
2. Check your credentials in `.env`
3. Test connection manually with `psql`

**"database does not exist"**
```bash
bundle exec rails db:create
```

## Example Configurations

### Docker PostgreSQL (common setup):
```env
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
OPENAI_API_KEY=sk-abc123...
RAILS_ENV=development
RAILS_MAX_THREADS=5
```

### Remote PostgreSQL:
```env
DB_HOST=db.example.com
DB_PORT=5432
DB_USERNAME=myuser
DB_PASSWORD=mypassword
OPENAI_API_KEY=sk-abc123...
RAILS_ENV=development
RAILS_MAX_THREADS=5
```

### Local PostgreSQL (with custom port):
```env
DB_HOST=localhost
DB_PORT=5433
DB_USERNAME=postgres
DB_PASSWORD=mypassword
OPENAI_API_KEY=sk-abc123...
RAILS_ENV=development
RAILS_MAX_THREADS=5
```

## Need Help?

- PostgreSQL connection issues: `psql -h localhost -U postgres`
- Rails database issues: Check `log/development.log`
- OpenAI API: https://platform.openai.com/docs

## Security Notes

- Never commit `.env` to version control
- Don't share your OpenAI API key
- Use strong passwords for PostgreSQL
- Consider using environment variables in production
