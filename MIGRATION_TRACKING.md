# Migration Tracking (Flyway-like Metadata)

Your Rails project now has enhanced migration tracking similar to Flyway's `flyway_schema_history` table.

## What's Included

### 1. Migration Metadata Table

The `migration_metadata` table tracks:
- **version** - Migration timestamp/version
- **description** - Human-readable migration name
- **migration_type** - Type (versioned, backfilled, etc.)
- **script_name** - Migration filename
- **checksum** - MD5 hash of migration file
- **installed_by** - User who ran the migration
- **installed_at** - When it was executed
- **execution_time_ms** - How long it took to run
- **success** - Whether it succeeded
- **error_message** - Any error that occurred

### 2. Automatic Tracking

Migrations are automatically tracked when you run:
```bash
rails db:migrate
```

The system captures:
- Execution time in milliseconds
- Who ran the migration (from $USER environment variable)
- File checksums for verification
- Success/failure status

### 3. Rake Tasks

#### View Migration History (Flyway-like `info` command)
```bash
rails db:migrate:info
```

Displays a formatted table with all migration metadata:
```
┌─────────────────────┬──────────────────────────────────┬─────────────┬────────────┬──────────────────────┬─────────────┐
│ Version             │ Description                      │ Type        │ Installed By│ Installed At         │ Exec Time   │
├─────────────────────┼──────────────────────────────────┼─────────────┼────────────┼──────────────────────┼─────────────┤
│ ✓ 20251013230145    │ Create projects                  │ versioned   │ jdoe       │ 2025-10-14 16:03:19 │        10ms │
└─────────────────────┴──────────────────────────────────┴─────────────┴────────────┴──────────────────────┴─────────────┘
```

#### View Checksums
```bash
rails db:migrate:checksums
```

Shows MD5 checksums for all migrations to detect tampering:
```
20251013230145: f68a97b9233cb1a74d237949023c5d33 (20251013230145_create_projects.rb)
```

#### Backfill Existing Migrations
```bash
rails db:migrate:backfill_metadata
```

Adds metadata for migrations that ran before this tracking system was installed.

## Comparison with Flyway

| Feature | Flyway | Rails + Tracking |
|---------|--------|------------------|
| Version tracking | ✅ | ✅ |
| Description | ✅ | ✅ |
| Checksums | ✅ | ✅ |
| Execution time | ✅ | ✅ |
| Installed by | ✅ | ✅ |
| Success/failure | ✅ | ✅ |
| Script name | ✅ | ✅ |
| Error messages | ❌ | ✅ |

## Model Access

Query migration metadata programmatically:

```ruby
# Get all successful migrations
MigrationMetadata.successful

# Get failed migrations
MigrationMetadata.failed

# Get recent migrations
MigrationMetadata.recent.limit(10)

# Find a specific migration
MigrationMetadata.find_by(version: '20251013230145')

# Check execution time
migration = MigrationMetadata.last
puts migration.execution_time  # "10ms"
```

## Files Created

- `/db/migrate/20251013000000_create_migration_metadata.rb` - Table migration (first migration)
- `/app/models/migration_metadata.rb` - ActiveRecord model
- `/config/initializers/migration_tracker.rb` - Automatic tracking hook
- `/lib/tasks/migration_info.rake` - Rake tasks for viewing metadata

## Notes

- The `migration_metadata` table is created as the **first migration** (version 20251013000000)
- This ensures all subsequent migrations are tracked from the start
- The metadata migration itself is tracked with full metadata
- Checksums help detect if migration files have been modified after execution
- All migrations are automatically tracked with full metadata including execution time and user info

