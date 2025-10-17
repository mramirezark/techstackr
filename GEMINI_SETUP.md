# 🚀 Google Gemini AI Setup (FREE & Easy!)

## Why Gemini?
After extensive testing, we switched from Hugging Face to Google Gemini because:
- ✅ **100% FREE** - 1,500 requests/day, 15 RPM (more than enough for development)
- ✅ **NO credit card required**
- ✅ **Works immediately** - No deployment or model loading needed
- ✅ **Reliable** - Google's infrastructure, always available
- ✅ **Fast** - Gemini 1.5 Flash is optimized for speed
- ✅ **High Quality** - Excellent for tech recommendations

## Get Your FREE API Key (Takes 1 Minute!)

### Step 1: Get API Key
1. Go to **[Google AI Studio](https://makersuite.google.com/app/apikey)**
2. Click **"Get API Key"** or **"Create API Key"**
3. Select **"Create API key in new project"** (or use existing project)
4. **COPY** the API key (starts with `AIza...`)

### Step 2: Add to Your App
1. Open `/workspace/techstackr/.env`
2. Find the line: `GEMINI_API_KEY=your-gemini-api-key-here`
3. Replace with your actual key:
   ```
   GEMINI_API_KEY=AIzaSyC...YourActualKeyHere
   ```
4. Save the file

### Step 3: Install the Gem
```bash
cd /workspace/techstackr
bundle install
```

### Step 4: Test It!
```bash
bin/rails runner "
  user = User.first || User.create!(username: 'testuser', password: 'password123', password_confirmation: 'password123')
  project = user.projects.create!(
    title: 'AI E-commerce Platform',
    description: 'A modern online store with real-time inventory and personalized recommendations',
    project_type: 'web_application',
    industry: 'E-commerce',
    estimated_team_size: 8
  )
  
  puts '🤖 Generating AI recommendations with Google Gemini...'
  service = AiRecommendationService.new(project)
  result = service.generate_recommendation
  
  if result[:error]
    puts \"❌ Error: #{result[:error]}\"
  else
    puts '✅ SUCCESS!'
    puts \"📋 Summary: #{result['summary']}\"
    puts \"🛠️  Technologies: #{result['technologies']&.length}\"
    puts \"👥 Team roles: #{result['team_composition']&.length}\"
  end
"
```

## Free Tier Limits

| Feature | Free Tier |
|---------|-----------|
| Requests per minute (RPM) | 15 |
| Requests per day | 1,500 |
| Tokens per minute | 1 million |
| Cost | **$0.00** |
| Credit card required | **NO** |

For your TechStackr app, this means:
- ~1,500 tech stack recommendations per day
- Perfect for development and testing
- No surprise bills ever

## Models Available

Your app uses **Gemini 1.5 Flash** which is:
- Fast (optimized for low latency)
- FREE
- Great for structured outputs like JSON
- Context window: 1M tokens

## Troubleshooting

### Error: "API key not configured"
- Make sure you added the key to `.env`
- Restart your Rails server: `bin/dev`
- Verify the key starts with `AIza`

### Error: "API key not valid"
- Double-check you copied the full key
- Make sure there are no extra spaces
- Try generating a new key in Google AI Studio

### Error: "Quota exceeded"
- Free tier: 1,500 requests/day
- Wait until tomorrow or upgrade (still very cheap)
- Check your usage: https://makersuite.google.com/app/apikey

## What Happened to Hugging Face?

We tried Hugging Face extensively but encountered issues:
- Most free models aren't deployed on inference providers
- Models return 404 errors even with valid API tokens
- The free Serverless Inference API appears to be restricted
- Would require paid Inference Endpoints ($0.06/hour minimum)

Gemini is a better choice for free, reliable AI!

## Next Steps

After testing locally:
1. Your app will generate awesome tech recommendations!
2. The UI already works - just add your API key
3. Consider the paid tier only if you need 1,500+ requests/day

Enjoy your free AI-powered tech recommendations! 🎉

