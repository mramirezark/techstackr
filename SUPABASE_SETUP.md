# Database Setup Guide for TechStackr

This guide will help you set up and switch between PostgreSQL and Supabase across all environments (development, test, and production).

## Prerequisites

1. A Supabase account (sign up at https://supabase.com)
2. A new Supabase project created

## Step 1: Create Supabase Project

1. Go to https://supabase.com/dashboard
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - Name: `techstackr`
   - Database Password: (choose a strong password)
   - Region: (choose closest to your users)
5. Click "Create new project"

## Step 2: Get Supabase Credentials

After your project is created, go to Settings > API:

1. **Project URL**: Copy the Project URL (e.g., `https://your-project-id.supabase.co`)
2. **Anon Key**: Copy the `anon` `public` key
3. **Service Role Key**: Copy the `service_role` `secret` key

## Step 3: Get Database Connection String

Go to Settings > Database:

1. **Connection String**: Copy the URI connection string
   - Format: `postgresql://postgres:[password]@db.[project-id].supabase.co:5432/postgres`
   - Replace `[password]` with your database password

## Step 4: Environment Variables

### Option 1: PostgreSQL (Default)
```bash
# Uses local PostgreSQL - no environment variables needed
# Or customize with:
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_NAME=techstackr
```

### Option 2: Supabase
```bash
# Use the same variable names as PostgreSQL
DB_HOST=db.your-project-id.supabase.co
DB_PASSWORD=your-database-password
DB_SSL=require
# Optional:
DB_PORT=5432
DB_USERNAME=postgres
DB_NAME=postgres
```

### Option 3: DATABASE_URL (Simplest)
```bash
# Single connection string for any environment
DATABASE_URL=postgresql://postgres:[password]@[host]:5432/[database]
```

## Step 5: Run Database Migrations

### Using PostgreSQL (Default):
```bash
# All environments use PostgreSQL
bundle install
rails db:create
rails db:migrate
rails db:seed
```

### Using Supabase:
```bash
# Set environment variables (same names as PostgreSQL)
export DB_HOST=db.your-project-id.supabase.co
export DB_PASSWORD=your-password
export DB_SSL=require

# Run migrations
rails db:migrate
rails db:seed
```

### Switching Between Providers:
```bash
# Use PostgreSQL (default)
unset DB_HOST
unset DB_SSL
rails db:migrate

# Use Supabase
export DB_HOST=db.your-project-id.supabase.co
export DB_PASSWORD=your-password
export DB_SSL=require
rails db:migrate

# Use DATABASE_URL
export DATABASE_URL=postgresql://user:pass@host:5432/db
rails db:migrate
```

## Step 6: Test Connections

### Test Development Connection:
```bash
rails console
# In Rails console:
ActiveRecord::Base.connection.execute("SELECT version();")
```

### Test Production Connection:
```bash
RAILS_ENV=production rails console
# In Rails console:
ActiveRecord::Base.connection.execute("SELECT version();")
```

## Step 7: Deploy to Production

When deploying to production (Heroku, Railway, etc.), set these environment variables:

```bash
# Required
DATABASE_URL=postgresql://postgres:[password]@db.[project-id].supabase.co:5432/postgres
RAILS_ENV=production
SECRET_KEY_BASE=your-secret-key-base

# Optional (for Supabase features)
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

## Database Schema

The application will automatically create these tables in Supabase:
- `users` - User accounts
- `projects` - User projects
- `recommendations` - AI-generated recommendations
- `technologies` - Technology recommendations
- `team_members` - Team member recommendations
- `migration_metadata` - Migration tracking

## Security Notes

1. **Never commit** `.env` files to version control
2. **Use strong passwords** for your Supabase database
3. **Rotate keys** regularly in production
4. **Enable Row Level Security (RLS)** in Supabase if needed
5. **Use environment variables** for all sensitive data

## Troubleshooting

### Connection Issues:
- Verify your Supabase project is active
- Check that your IP is whitelisted (if using IP restrictions)
- Ensure the connection string is correct

### Migration Issues:
- Make sure you're using the correct database user
- Check that the database exists
- Verify your credentials are correct

### Performance:
- Supabase has connection limits on the free tier
- Consider connection pooling for high-traffic applications
- Monitor your usage in the Supabase dashboard

## Support

- Supabase Documentation: https://supabase.com/docs
- Supabase Community: https://github.com/supabase/supabase/discussions
- Rails Database Guide: https://guides.rubyonrails.org/active_record_basics.html
