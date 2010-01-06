require 'rubygems'
require 'rake'
require 'yaml'

namespace :db do
  db = "db/food.db"
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

  namespace :pop do
    desc "Populate the foods table."
    task :foods do
      class YamlFood
        attr_accessor :name, :rfid, :major, :minor, :room_start, :room_end,
                      :fridge_start, :fridge_end, :freezer_start, :freezer_end
      end

      require 'db/init'
      Food.delete

      File.open('db/fixtures/foods2.yaml') do |file|
        i = 0
        YAML.load_documents(file) do |f|
          food = Food.new(:name => f.name, :rfid => f.rfid,
                          :major => f.major.to_s, :minor => f.minor.to_s,
                          :room_start => f.room_start, :room_end => f.room_end,
                          :fridge_start => f.fridge_start, :fridge_end => f.fridge_end,
                          :freezer_start => f.freezer_start, :freezer_end => f.freezer_end)
          food.id = i+=1
          food.save
        end
      end
    end

    desc "Populate the users table."
    task :users do
      require 'db/init'
      User.delete

      File.open('db/fixtures/users.yaml') do |file|
        YAML.load_documents(file) do |u|
          user = User.new
          user.id = u.values[:id]
          user.name = u.values[:name]
          user.email = u.values[:email]
          user.scanner_id = u.values[:scanner_id]
          puts user.inspect
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
