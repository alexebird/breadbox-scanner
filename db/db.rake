require 'rubygems'
require 'rake'
require 'yaml'

RAKE_DB_ROOT = File.expand_path(File.dirname(__FILE__))
require File.join(RAKE_DB_ROOT, 'init')

task :prod do
  FoodDB::DatabaseConfig.env = 'production'
end

namespace :db do

  desc "If mig is not specified, task will run the most recent migration.\n" +
       "Otherwise run the migration specified by mig."
  task :migrate , [:mig] => [:create_sqlite] do |t, args|
    sh "sequel -m #{FoodDB[:migations_path]} -M #{FoodDB.migration(args.mig)} #{FoodDB::DatabaseConfig.sequel_string}"
  end

  task :create_sqlite do
    if FoodDB::DatabaseConfig.sqlite? && File.exists?(FoodDB::DatabaseConfig.sqlite_file)
      sh "touch #{FoodDB::DatabaseConfig.sqlite_file}"
    end
  end
  
  desc "Run the Sequel console."
  task :console do
    sh "irb -r rubygems -r sequel -r #{File.join(RAKE_DB_ROOT, 'init')}"
  end

  desc "Delete sqlite database file."
  task :clobber => [:create_sqlite] do
    sh "truncate --size=0 #{FoodDB::DatabaseConfig.sqlite_file}" if FoodDB::DatabaseConfig.sqlite?
  end

  desc "Show the actual dev sqlite3 schema."
  task :schema do
    sh "sqlite3 #{FoodDB::DatabaseConfig.sqlite_file} .schema" if FoodDB::DatabaseConfig.sqlite?
  end

  desc "Migrate and populate the database."
  task :refresh => [:migrate, :pop]

  namespace :pop do

    desc "Populate the foods table."
    task :foods do
      FoodDB.load_models
      Food.delete
      Food.unrestrict_primary_key

      File.open(FoodDB.fixtures[:foods]) do |file|
        YAML.load_documents(file) do |f|
          Food.create(f.values)
        end
      end
    end

    desc "Populate the users table."
    task :users do
      FoodDB.load_models
      User.delete
      User.unrestrict_primary_key

      File.open(FoodDB.fixtures[:users]) do |file|
        YAML.load_documents(file) do |u|
          User.create(u.values)
        end
      end
    end

    desc "Populate the scanners table."
    task :scanners do
      FoodDB.load_models
      Scanner.delete
      Scanner.unrestrict_primary_key

      File.open(FoodDB.fixtures[:scanners]) do |file|
        YAML.load_documents(file) do |s|
          Scanner.create(s.values)
        end
      end
    end
  end

  desc "Populate all tables."
  task :pop => ['pop:foods', 'pop:users', 'pop:scanners']
end
