namespace :db do
  namespace :migrate do
    desc "Display migration history (Flyway-like info)"
    task info: :environment do
      require "io/console"

      unless ActiveRecord::Base.connection.table_exists?("migration_metadata")
        puts "Migration metadata table doesn't exist. Run 'rails db:migrate' first."
        exit
      end

      migrations = MigrationMetadata.order(:version).all

      if migrations.empty?
        puts "No migration metadata recorded yet."
        puts "The tracker will start recording after you run 'rails db:migrate'."
        exit
      end

      # Table header
      puts "\n┌─────────────────────┬──────────────────────────────────┬─────────────┬────────────┬──────────────────────┬─────────────┐"
      puts "│ Version             │ Description                      │ Type        │ Installed By│ Installed At         │ Exec Time   │"
      puts "├─────────────────────┼──────────────────────────────────┼─────────────┼────────────┼──────────────────────┼─────────────┤"

      migrations.each do |migration|
        status_icon = migration.success ? "✓" : "✗"
        version = migration.version.ljust(19)
        description = migration.description.to_s[0..32].ljust(32)
        type = migration.migration_type.to_s.ljust(11)
        installed_by = migration.installed_by.to_s[0..10].ljust(10)
        installed_at = migration.installed_at.strftime("%Y-%m-%d %H:%M:%S")
        exec_time = "#{migration.execution_time_ms}ms".rjust(11)

        puts "│ #{status_icon} #{version} │ #{description} │ #{type} │ #{installed_by} │ #{installed_at} │ #{exec_time} │"
      end

      puts "└─────────────────────┴──────────────────────────────────┴─────────────┴────────────┴──────────────────────┴─────────────┘"

      # Summary
      total = migrations.count
      successful = migrations.successful.count
      failed = migrations.failed.count

      puts "\nSummary:"
      puts "  Total migrations: #{total}"
      puts "  Successful: #{successful}"
      puts "  Failed: #{failed}" if failed > 0
      puts ""
    end

    desc "Display migration checksums"
    task checksums: :environment do
      unless ActiveRecord::Base.connection.table_exists?("migration_metadata")
        puts "Migration metadata table doesn't exist."
        exit
      end

      migrations = MigrationMetadata.order(:version).all

      puts "\nMigration Checksums:\n\n"
      migrations.each do |migration|
        puts "#{migration.version}: #{migration.checksum} (#{migration.script_name})"
      end
      puts ""
    end

    desc "Backfill metadata for existing migrations"
    task backfill_metadata: :environment do
      unless ActiveRecord::Base.connection.table_exists?("migration_metadata")
        puts "Migration metadata table doesn't exist. Run 'rails db:migrate' first."
        exit
      end

      applied_versions = ActiveRecord::Base.connection.select_values(
        "SELECT version FROM schema_migrations ORDER BY version"
      )

      applied_versions.each do |version|
        next if MigrationMetadata.exists?(version: version)

        file = MigrationMetadata.find_migration_file(version)
        description = file.to_s.gsub(/^\d+_/, "").gsub(".rb", "").underscore.humanize

        MigrationMetadata.create!(
          version: version,
          description: description,
          script_name: file,
          checksum: MigrationMetadata.calculate_checksum(version),
          installed_by: "backfilled",
          installed_at: Time.current,
          migration_type: "backfilled",
          success: true
        )

        puts "✓ Backfilled metadata for: #{version} - #{description}"
      end

      puts "\nBackfill complete!"
    end
  end
end
