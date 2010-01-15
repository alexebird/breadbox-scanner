require 'rubygems'
require 'rake'
require 'yaml'

RAKE_DB_ROOT = File.expand_path(File.dirname(__FILE__))
require File.join(RAKE_DB_ROOT, 'init')

desc "Set the database enviroment. env can be dev,test,prod."
task :setenv, [:env] do |t, args|
  if args.env && %w(dev test prod).include?(args.env)
    FoodDB::DatabaseConfig.env = case args.env
                                   when 'prod' then 'production'
                                   when 'test' then 'test'
                                   when 'dev' then 'development'
                                 end
  end
end

namespace :setenv do
  task :dev do
    Rake::Task["setenv"].invoke 'dev'
  end
  task :test do
    Rake::Task["setenv"].invoke 'test'
  end
  task :prod do
    Rake::Task["setenv"].invoke 'prod'
  end
end

namespace :db do
  task :beforetests => ['setenv:test', 'pop']

  desc "If mig is not specified, task will run the most recent migration.\n" +
       "Otherwise run the migration specified by mig."
  task :migrate, [:env, :mig] => [:create_sqlite] do |t, args|
    Rake::Task["setenv"].invoke args.env
    sh "sequel -m #{FoodDB[:migations_path]} -M #{FoodDB.migration(args.mig)} #{FoodDB::DatabaseConfig.sequel_string}"
  end

  desc "Reload the latest migration."
  task :remigrate, [:env] => [:create_sqlite] do |t, args|
    Rake::Task["setenv"].invoke args.env
    mig = FoodDB.migration(nil)
    if mig > 1
      sh "sequel -m #{FoodDB[:migations_path]} -M #{mig - 1} #{FoodDB::DatabaseConfig.sequel_string}"
      sh "sequel -m #{FoodDB[:migations_path]} -M #{mig} #{FoodDB::DatabaseConfig.sequel_string}"
    end
  end

  task :create_sqlite do
    if FoodDB::DatabaseConfig.sqlite? && File.exists?(FoodDB::DatabaseConfig.sqlite_file)
      sh "touch #{FoodDB::DatabaseConfig.sqlite_file}"
    end
  end
  
  desc "Run the Sequel console."
  task :console do
    sh "irb -r rubygems -r sequel -r #{File.join(RAKE_DB_ROOT, 'init')} -r #{File.join(RAKE_DB_ROOT, 'irb-init.rb')}"
  end

  desc "Run the mysql console."
  task :mysql do
    sh "mysql -u %s -p%s -h %s -D %s" % FoodDB::DatabaseConfig.mysql_args
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
  task :pop, [:env] do |t, args|
    Rake::Task["setenv"].invoke args.env

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
    desc "Run all model tests."
    task :model do
      Rake::Task['db:pop'].invoke 'test'
      cd "db" do
        sh "spec -r spec/spec_helper --format specdoc -c spec/"
      end
    end
  end

  desc "Run all database tests."
  task :db => ['db:model']
end
