class CreateMigrationMetadata < ActiveRecord::Migration[7.2]
  def change
    create_table :migration_metadata do |t|
      t.string :version, null: false
      t.string :description
      t.string :migration_type, default: 'versioned'
      t.string :script_name
      t.string :checksum
      t.string :installed_by
      t.datetime :installed_at
      t.integer :execution_time_ms
      t.boolean :success, default: true
      t.text :error_message

      t.timestamps

      t.index :version, unique: true
      t.index :installed_at
    end
  end
end
