require 'rubygems'
require 'rake'
require 'yaml'

namespace :db do
  db = "db/development.db"
  mig_dir = "db/migrations"

  desc "If mig is not specified, task will run the most recent migration.\n" +
       "Otherwise run the migration specified by mig."
  task :migrate , [:mig] => [:create] do |t, args|
    if args.mig
      mig = args.mig
    else
      migrations = Dir.entries(mig_dir) - ['.', '..']
      migrations.map! {|e| e.scan(/\d+(?=_)/).first.to_i }.sort!
      mig = migrations.last
    end
    sh "sequel -m #{mig_dir} -M #{mig} sqlite://#{db}"
  end
  
  desc "Create the sqlite3 database file."
  task :create do
    sh "touch #{db}"
  end

  desc "Run the Sequel console."
  task :console do
    sh "sequel sqlite://#{db}"
  end

  namespace :pop do
    desc "Populate the foods table."
    task :foods do
      require 'db/init'
      Food.delete
      Food.unrestrict_primary_key

      File.open('db/fixtures/foods.yml') do |file|
        YAML.load_documents(file) do |f|
          food = Food.new(f.values)
          food.save
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
          user = User.new(u.values)
          user.save
        end
      end
    end
  end
  desc "Populate all tables."
  task :pop => ['pop:foods', 'pop:users']
end


namespace :run do
  desc "Run the server which listens for RFID scans."
  task :server do
    sh "ruby -C scan-server init.rb"
  end

  desc "Run the web server."
  task :web do
    sh "ruby -C website start.rb"
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
  desc "Run all scan server tests."
  task :scanserver do
    cd "scan-server" do
      sh "spec --format specdoc -c spec/scan_server_server_spec.rb"
      sh "spec --format specdoc -c spec/time_ago_in_words_spec.rb"
    end
  end

end
desc "Run all tests."
task :test => ['test:scanserver']
