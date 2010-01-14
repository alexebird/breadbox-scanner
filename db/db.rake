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

  desc "Populate the database from fixtures."
  task :pop do
    FoodDB.connect :log_to_console => true

    Food.delete
    Food.unrestrict_primary_key
    File.open(FoodDB.fixtures[:foods]) do |file|
      YAML.load_documents(file) do |f|
        Food.create(f.values)
      end
    end

    User.delete
    User.unrestrict_primary_key
    File.open(FoodDB.fixtures[:users]) do |file|
      YAML.load_documents(file) do |u|
        User.create(u.values)
      end
    end

    Scanner.delete
    Scanner.unrestrict_primary_key
    File.open(FoodDB.fixtures[:scanners]) do |file|
      YAML.load_documents(file) do |s|
        Scanner.create(s.values)
      end
    end

    Scan.delete
    Scan.unrestrict_primary_key
    File.open(FoodDB.fixtures[:scans]) do |file|
      YAML.load_documents(file) do |s|
        Scan.create(s.values)
      end
    end

    scans = Scan.all
    scanner = Scanner.first
    user = scanner.user
    user.add_scanner(scanner)
    foods = Food.all
    scans.each do |scan|
      scanner.add_scan(scan)
      user.scan_food(scan.food)
      scan.food.add_scan(scan)
    end
  end
end

namespace :test do
  namespace :db do
    task :setup do
      ENV['DB_ENV'] = 'test'
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:pop'].invoke
    end

    desc "Run all model tests."
    task :model => :setup do
      cd "db" do
        sh "spec -r init --format specdoc -c spec/"
      end
    end
  end

  desc "Run all database tests."
  task :db => ['db:setup', 'db:model']
end
