require 'rubygems'
require 'rake'

default_db = "development"
ENV['db_env'] = default_db

namespace :db do
  db = Proc.new { "db/#{ENV['db_env']}.db" }

  desc "If mig is not specified, task will run the most recent migration.\n" +
       "Otherwise run the migration specified by mig."
  task :migrate , [:mig] => [:clobber, :create] do |t, args|
    mig_dir = "db/migrations"
    if args.mig
      mig = args.mig
    else
      migrations = Dir.entries(mig_dir) - ['.', '..']
      migrations.map! {|e| e.scan(/\d+(?=_)/).first.to_i }.sort!
      mig = migrations.last
    end
    sh "sequel -m #{mig_dir} -M #{mig} sqlite://#{db.call}"
  end
  
  desc "Create the sqlite3 database file."
  task :create do
    sh "touch #{db.call}"
  end

  desc "Run the Sequel console."
  task :console do
    sh "irb -r rubygems -r sequel -r db/init"
  end

  desc "Delete sqlite database files."
  task :clobber do
    sh "rm -v #{db.call}"
  end

  desc "Show the sqlite3 schema."
  task :schema do
    sh "sqlite3 #{db.call} .schema"
  end

  require 'yaml'
  namespace :pop do
    desc "Populate the foods table."
    task :foods do
      require 'db/init'
      Food.delete
      Food.unrestrict_primary_key

      File.open('db/fixtures/foods.yml') do |file|
        YAML.load_documents(file) do |f|
          Food.create(f.values)
        end
      end
    end

    desc "Populate the users table."
    task :users do
      require 'db/init'
      User.delete
      User.unrestrict_primary_key

      File.open('db/fixtures/users.yml') do |file|
        YAML.load_documents(file) do |u|
          User.create(u.values)
        end
      end
    end

    desc "Populate the scanners table."
    task :scanners do
      require 'db/init'
      Scanner.delete
      Scanner.unrestrict_primary_key

      File.open('db/fixtures/scanners.yml') do |file|
        YAML.load_documents(file) do |s|
          Scanner.create(s.values)
        end
      end
    end
  end
  desc "Populate all tables."
  task :pop => ['pop:foods', 'pop:users', 'pop:scanners']
end

namespace :run do
  desc "Run the server which listens for RFID scans."
  task :server do
    sh "ruby -C scan_server init.rb"
  end

  desc "Run the web server."
  task :www do
    sh "ruby -C www start.rb"
  end

  desc "Run the mock arduino."
  task :scanner do
    sh "ruby -C scanner/mock mock_arduino.rb"
  end
end

namespace :doc do
  desc "Generate rdoc for the README."
  task :readme do
    sh "rdoc README"
  end
end
desc "Generate all rdocs."
task :doc => ['doc:readme']

namespace :test do
  task :setup_test_db do
    ENV['db_env'] = 'test'
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:pop'].invoke
  end

  desc "Run all scan server tests."
  task :scanserver do
    cd "scan_server" do
      sh "spec --format specdoc -c spec/"
    end
  end

  namespace :scanserver do 
    desc "Run the time in words methods."
    task :time do
      cd "scan_server" do
        sh "spec --format specdoc -c spec/time_diff_in_words_spec.rb"
      end
    end
  end

  desc "Run all model tests."
  task :model => :setup_test_db do
    cd "db" do
      sh "spec -r init --format specdoc -c spec/"
    end
  end
end
desc "Run all tests."
task :test => ['test:scanserver', 'test:model']
