require 'rubygems'
require 'rake'
require 'yaml'
require 'db/init'

db = "db/food.db"

namespace "db" do

  desc "Run the most recent migration."
  task :migrate , [:mig] => [db] do |t, args|
    if args.mig
      mig = args.mig
    else
      migrations = Dir.entries("db/migrations") - ['.', '..']
      migrations.map! {|e| e.scan(/\d+(?=_)/).first }.sort!
      mig = migrations.last
    end
    sh "sequel -m db/migrations -M #{mig} sqlite://#{db}"
  end

  namespace :pop do

    desc "Populate the foods table."
    task :foods do
      Food.delete

      File.open('db/fixtures/foods.yaml') do |file|
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
  end
end

desc "Create the sqlite3 database file"
file db do |t|
  sh "touch #{t.name}"
end

class YamlFood
  attr_accessor :name, :rfid,
                :major, :minor,
                :room_start, :room_end,
                :fridge_start, :fridge_end,
                :freezer_start, :freezer_end
end
