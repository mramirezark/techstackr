# TechStackr Deployment Guide

## Deploy to Render

### Prerequisites
1. GitHub repository with your code
2. Render account (free tier available)
3. Google Gemini API key

### Step 1: Prepare Your Repository

1. **Commit all changes:**
   ```bash
   git add .
   git commit -m "Prepare for Render deployment"
   git push origin main
   ```

2. **Verify files are in place:**
   - `render.yaml` ✅
   - `config/puma.rb` ✅
   - `config/environments/production.rb` ✅
   - `public/manifest.json` ✅

### Step 2: Create Render Account & Connect Repository

1. Go to [render.com](https://render.com)
2. Sign up with GitHub
3. Click "New +" → "Web Service"
4. Connect your GitHub repository
5. Select your `techstackr` repository

### Step 3: Configure Web Service

**Basic Settings:**
- **Name**: `techstackr`
- **Environment**: `Ruby`
- **Region**: Choose closest to your users
- **Branch**: `main`
- **Root Directory**: Leave empty (root)

**Build & Deploy:**
- **Build Command**: 
  ```bash
  bundle install
  bundle exec rails assets:precompile
  bundle exec rails db:migrate
  ```
- **Start Command**: 
  ```bash
  bundle exec puma -C config/puma.rb
  ```

### Step 4: Set Environment Variables

In Render dashboard, go to Environment tab and add:

**Required Variables:**
```
RAILS_ENV=production
RAILS_MASTER_KEY=your_master_key_here
GEMINI_API_KEY=your_gemini_api_key_here
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

**Database Variables (Auto-generated):**
```
DATABASE_URL=postgresql://user:pass@host:port/dbname
```

### Step 5: Create Database

1. In Render dashboard, click "New +" → "PostgreSQL"
2. **Name**: `techstackr-db`
3. **Plan**: Starter (Free)
4. **Database Name**: `techstackr_production`
5. **User**: `techstackr_user`
6. Click "Create Database"

### Step 6: Link Database to Web Service

1. Go to your web service settings
2. In Environment Variables, add:
   ```
   DATABASE_URL=postgresql://user:pass@host:port/dbname
   ```
   (Copy from your database service)

### Step 7: Deploy

1. Click "Create Web Service"
2. Render will automatically:
   - Clone your repository
   - Install dependencies
   - Precompile assets
   - Run database migrations
   - Start your application

### Step 8: Get Your Master Key

If you don't have a master key:

1. **Generate new credentials:**
   ```bash
   rails credentials:edit
   ```

2. **Get the master key:**
   ```bash
   cat config/master.key
   ```

3. **Add to Render environment variables:**
   ```
   RAILS_MASTER_KEY=your_master_key_here
   ```

### Step 9: Verify Deployment

1. **Check logs** in Render dashboard
2. **Visit your app** at the provided URL
3. **Test functionality:**
   - Create a project
   - Generate AI recommendations
   - Check database connectivity

### Troubleshooting

**Common Issues:**

1. **Build fails:**
   - Check Ruby version compatibility
   - Verify all gems are in Gemfile
   - Check for missing dependencies

2. **Database connection fails:**
   - Verify DATABASE_URL is correct
   - Check database service is running
   - Ensure migrations ran successfully

3. **Assets not loading:**
   - Verify RAILS_SERVE_STATIC_FILES=true
   - Check assets were precompiled
   - Look for asset compilation errors

4. **AI recommendations not working:**
   - Verify GEMINI_API_KEY is set
   - Check API key is valid
   - Look for API errors in logs

### Environment Variables Reference

| Variable | Description | Required |
|----------|-------------|----------|
| `RAILS_ENV` | Rails environment | Yes |
| `RAILS_MASTER_KEY` | Rails credentials key | Yes |
| `DATABASE_URL` | PostgreSQL connection string | Yes |
| `GEMINI_API_KEY` | Google Gemini API key | Yes |
| `RAILS_SERVE_STATIC_FILES` | Serve static files | Yes |
| `RAILS_LOG_TO_STDOUT` | Log to stdout | Yes |

### Cost Estimation

**Free Tier:**
- Web Service: 750 hours/month (free)
- Database: 1GB storage (free)
- Bandwidth: 100GB/month (free)

**Paid Plans:**
- Starter: $7/month (web service)
- Database: $7/month (1GB)

### Security Notes

1. **Never commit sensitive data** to repository
2. **Use environment variables** for all secrets
3. **Enable HTTPS** (automatic on Render)
4. **Regular backups** of database
5. **Monitor logs** for security issues

### Next Steps

1. **Set up custom domain** (optional)
2. **Configure monitoring** and alerts
3. **Set up CI/CD** for automatic deployments
4. **Configure backups** for database
5. **Set up staging environment** for testing

## Support

- **Render Documentation**: https://render.com/docs
- **Rails Deployment Guide**: https://guides.rubyonrails.org/deployment.html
- **Project Issues**: Check GitHub repository issues
