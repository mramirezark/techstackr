namespace :db do
  desc "Force reset database by terminating active connections first"
  task force_reset: :environment do
    db_config = ActiveRecord::Base.connection_db_config
    db_name = db_config.database

    puts "Terminating active connections to #{db_name}..."

    ActiveRecord::Base.connection.execute <<-SQL
      SELECT pg_terminate_backend(pg_stat_activity.pid)
      FROM pg_stat_activity
      WHERE pg_stat_activity.datname = '#{db_name}'
        AND pid <> pg_backend_pid();
    SQL

    puts "Active connections terminated."
    puts "Resetting database..."

    Rake::Task["db:reset"].invoke

    puts "Database force reset complete!"
  end

  desc "Force drop database by terminating active connections first"
  task force_drop: :environment do
    db_config = ActiveRecord::Base.connection_db_config
    db_name = db_config.database

    puts "Terminating active connections to #{db_name}..."

    ActiveRecord::Base.connection.execute <<-SQL
      SELECT pg_terminate_backend(pg_stat_activity.pid)
      FROM pg_stat_activity
      WHERE pg_stat_activity.datname = '#{db_name}'
        AND pid <> pg_backend_pid();
    SQL

    puts "Active connections terminated."
    puts "Dropping database..."

    Rake::Task["db:drop"].invoke

    puts "Database force drop complete!"
  end
end
