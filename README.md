# TechStackr 🚀

An AI-powered web application that provides technology stack recommendations and team composition suggestions for software projects.

## 📋 Overview

TechStackr helps PMs, recruiters, and technical leaders make informed decisions about technology choices and team composition by leveraging AI to analyze project requirements and provide tailored recommendations.

### Features

- **AI-Powered Recommendations**: Uses OpenAI's GPT models to generate technology stack suggestions
- **Team Composition Analysis**: Provides recommended team structure and roles
- **Project Management**: Track multiple projects and their recommendations
- **Modern Rails UI**: Clean, responsive interface built with Rails ERB views
- **Flexible Database**: Works with your existing PostgreSQL instance

## 🛠️ Tech Stack

### Backend
- **Ruby** 3.4.5
- **Rails** 7.2.2
- **PostgreSQL** 12+ (uses your existing instance)
- **OpenAI API** (GPT-4o-mini)

### Frontend
- **ERB Views** (Rails default templating)
- **Turbo & Stimulus** (Hotwire for modern interactions)
- **Custom CSS** (Modern, responsive design)

## 📦 Prerequisites

Before you begin, ensure you have the following:

- Ruby 3.4.5 or higher
- PostgreSQL running (you already have this! ✅)
- Bundler gem (`gem install bundler`)
- OpenAI API key ([Get one here](https://platform.openai.com/api-keys))

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd techstackr
```

### 2. Install Dependencies

```bash
# Configure bundler to install gems locally
bundle config set --local path 'vendor/bundle'

# Install dependencies
bundle install
```

### 3. Configure Database Connection

Create a `.env` file in the root directory with your PostgreSQL connection details:

```bash
cat > .env << 'ENVFILE'
# PostgreSQL Connection (adjust to match your setup)
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_postgres_password

# OpenAI API Configuration
OPENAI_API_KEY=sk-your-api-key-here

# Rails Configuration
RAILS_ENV=development
RAILS_MAX_THREADS=5
ENVFILE
```

**Important:** Update the PostgreSQL credentials to match your existing database:
- `DB_HOST`: Your PostgreSQL host (usually `localhost` if running locally)
- `DB_PORT`: Your PostgreSQL port (default is `5432`)
- `DB_USERNAME`: Your PostgreSQL username
- `DB_PASSWORD`: Your PostgreSQL password

### 4. Create the Database

This will create a new database called `techstackr_development` in your existing PostgreSQL instance:

```bash
# Create the database
bundle exec rails db:create

# Run migrations to set up the schema
bundle exec rails db:migrate
```

### 5. Start the Rails Server

```bash
# Start the development server
bundle exec rails server

# Or use the shorthand
bundle exec rails s
```

The application will be available at `http://localhost:3000`

## 📖 Usage

### Creating a Project

1. Navigate to `http://localhost:3000`
2. Click "Create New Project"
3. Fill in:
   - **Project Title**: A descriptive name for your project
   - **Project Type**: Select from web app, mobile app, API, etc.
   - **Description**: Detailed project requirements (be specific for better recommendations)
4. Click "Create Project"

### Generating Recommendations

1. On the project detail page, click "Generate AI Recommendations"
2. Wait for the AI to analyze your project (usually 5-15 seconds)
3. View the recommendations:
   - **Technology Stack**: Categorized by Frontend, Backend, Database, DevOps, etc.
   - **Team Composition**: Suggested roles, team size, and responsibilities

### Managing Projects

- **View All Projects**: Home page shows all your projects with status badges
- **Project Status**:
  - 🟡 **Pending**: Ready to generate recommendations
  - 🔵 **Processing**: AI is analyzing the project
  - 🟢 **Completed**: Recommendations available
  - 🔴 **Failed**: Generation failed, can retry

## 🔧 Configuration

### Environment Variables

The `.env` file in the root directory:

```env
# PostgreSQL Connection
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_password

# OpenAI API Configuration
OPENAI_API_KEY=sk-your-api-key-here

# Rails Configuration
RAILS_ENV=development
RAILS_MAX_THREADS=5
```

### Database Configuration

The application creates these databases in your PostgreSQL instance:
- `techstackr_development` - Development database
- `techstackr_test` - Test database (created automatically when running tests)
- `techstackr_production` - Production database (when deployed)

To verify your databases were created:
```bash
psql -h localhost -U postgres -l
```

To drop the databases if needed:
```bash
bundle exec rails db:drop
```

## 🗂️ Project Structure

```
techstackr/
├── app/
│   ├── controllers/       # Controllers
│   ├── models/           # ActiveRecord models
│   ├── services/         # Business logic (AI service)
│   └── views/            # ERB templates
├── config/
│   ├── database.yml      # Database configuration
│   └── routes.rb         # Application routes
├── db/
│   └── migrate/          # Database migrations
├── Gemfile               # Ruby dependencies
├── .env                  # Environment variables (create this!)
└── README.md             # This file
```

## 📊 Database Schema

### Projects
- `title`: string
- `description`: text
- `project_type`: string
- `status`: enum (pending, processing, completed, failed)

### Recommendations
- `project_id`: reference
- `ai_response`: text (full JSON response)
- `summary`: text

### Technologies
- `recommendation_id`: reference
- `name`: string
- `category`: string (Frontend, Backend, Database, etc.)
- `description`: text
- `reason`: text

### TeamMembers
- `recommendation_id`: reference
- `role`: string
- `count`: integer
- `skills`: text
- `responsibilities`: text

## 🔍 API Details

The application uses OpenAI's GPT-4o-mini model to generate recommendations. The AI is prompted with:
- Project title
- Project type
- Detailed description

And returns structured JSON with:
- Technology recommendations (categorized)
- Team composition suggestions
- Implementation considerations

## 🛠️ Development

### Running Migrations

```bash
bundle exec rails db:migrate
```

### Creating New Migrations

```bash
bundle exec rails generate migration MigrationName
```

### Rails Console

```bash
bundle exec rails console
```

### Checking Routes

```bash
bundle exec rails routes
```

### Database Management

```bash
# Create database
bundle exec rails db:create

# Run migrations
bundle exec rails db:migrate

# Rollback last migration
bundle exec rails db:rollback

# Reset database (drop, create, migrate)
bundle exec rails db:reset

# Seed database
bundle exec rails db:seed
```

## 🧪 Testing

```bash
bundle exec rails test
```

## 🐛 Troubleshooting

### PostgreSQL Connection Issues

1. **Verify PostgreSQL is running:**
   ```bash
   # If using Docker
   docker ps | grep postgres
   
   # Or check service status
   systemctl status postgresql
   ```

2. **Test connection manually:**
   ```bash
   psql -h localhost -U postgres -c "SELECT version();"
   ```

3. **Check your .env file:**
   ```bash
   cat .env
   ```

4. **Verify database exists:**
   ```bash
   psql -h localhost -U postgres -l | grep techstackr
   ```

### Common Database Errors

**Error: "database does not exist"**
```bash
bundle exec rails db:create
```

**Error: "relation does not exist"**
```bash
bundle exec rails db:migrate
```

**Error: "password authentication failed"**
- Check your `DB_PASSWORD` in `.env`
- Verify PostgreSQL user credentials

### Bundle Install Errors

If you encounter permission errors during `bundle install`:

```bash
# Configure bundle to install locally
bundle config set --local path 'vendor/bundle'
bundle install
```

### OpenAI API Errors

- Verify your API key is correct in `.env`
- Check your OpenAI account has credits
- Ensure no firewall is blocking API requests

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

We welcome contributions from the community! 

- 📖 Read our [Contributing Guide](CONTRIBUTING.md) to get started
- 🐛 Found a bug? [Report it here](../../issues/new?template=bug_report.md)
- 💡 Have an idea? [Submit a feature request](../../issues/new?template=feature_request.md)
- 🔒 Security issue? See our [Security Policy](SECURITY.md)

Please follow our code of conduct and contribution guidelines when participating.

## 📧 Support

- 📚 Check our [documentation](ENV_SETUP.md) for setup help
- 💬 Open a [Discussion](../../discussions) for questions
- 🐛 [Report bugs](../../issues/new?template=bug_report.md) via GitHub Issues
- 📖 See [Migration Tracking Guide](MIGRATION_TRACKING.md) for database migration info

---

Built with ❤️ using Ruby on Rails and OpenAI
