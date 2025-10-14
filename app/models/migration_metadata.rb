class MigrationMetadata < ApplicationRecord
  validates :version, presence: true, uniqueness: true

  scope :successful, -> { where(success: true) }
  scope :failed, -> { where(success: false) }
  scope :recent, -> { order(installed_at: :desc) }

  def self.record_migration(version, description, execution_time_ms, success: true, error: nil)
    create!(
      version: version,
      description: description,
      script_name: find_migration_file(version),
      checksum: calculate_checksum(version),
      installed_by: ENV["USER"] || ENV["USERNAME"] || "unknown",
      installed_at: Time.current,
      execution_time_ms: execution_time_ms,
      success: success,
      error_message: error
    )
  end

  def self.find_migration_file(version)
    file = Dir.glob(Rails.root.join("db/migrate/#{version}_*.rb")).first
    file ? File.basename(file) : "#{version}.rb"
  end

  def self.calculate_checksum(version)
    file = Dir.glob(Rails.root.join("db/migrate/#{version}_*.rb")).first
    return nil unless file && File.exist?(file)

    Digest::MD5.hexdigest(File.read(file))
  end

  def execution_time
    "#{execution_time_ms}ms" if execution_time_ms
  end
end
