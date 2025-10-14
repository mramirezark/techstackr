# Automatically track migration execution with Flyway-like metadata
module MigrationTracker
  def migrate(direction)
    return super unless direction == :up && defined?(MigrationMetadata)

    start_time = Time.current
    error = nil
    success = true

    begin
      super
    rescue => e
      error = e.message
      success = false
      raise
    ensure
      execution_time = ((Time.current - start_time) * 1000).to_i

      # Record the migration metadata
      begin
        MigrationMetadata.record_migration(
          version.to_s,
          name.underscore.humanize,
          execution_time,
          success: success,
          error: error
        )
      rescue ActiveRecord::StatementInvalid => e
        # Skip if migration_metadata table doesn't exist yet
        Rails.logger.debug "Skipping migration tracking: #{e.message}"
      end
    end
  end
end

# Prepend to all migrations
ActiveRecord::Migration.prepend(MigrationTracker)
