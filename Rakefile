require 'rubygems'
require 'rake'
require 'yaml'
require 'db/init'

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
      User.delete

      File.open('db/fixtures/users.yaml') do |file|
        YAML.load_documents(file) do |u|
          user = User.new
          user.id = u.values[:id]
          user.name = u.values[:name]
          user.email = u.values[:email]
          puts user.inspect
          user.save
        end
      end
    end

    desc "Populate all tables."
    task :all => [:foods, :users]
  end
end


namespace :run do
  desc "Run the server which listens for RFID scans."
  task :scan do
    sh "ruby -C server init.rb"
  end

  desc "Run the web server."
  task :web do
    sh "ruby -C website start.rb"
  end

  desc "Run the mock arduino."
  task :arduino do
    sh "ruby -C arduino/mock mock_arduino.rb"
  end
end
