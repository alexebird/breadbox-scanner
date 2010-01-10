require 'rubygems'
require 'sequel'
require 'logger'

module FoodDB
  @options = {}
  @options[:root] = ENV['DB_ROOT']
  @options[:fixtures_path] = File.join(@options[:root], 'fixtures')
  @options[:migations_path] = File.join(@options[:root], 'migrations')
  @options[:logger] = Logger.new(STDOUT)

  class << self
    def [](option)
      @options[option]
    end

    def []=(option, value)
      @options[option] = value
    end

    def migration(migration_number)
      migrations = Dir.glob(@options[:migations_path] + '/*.rb')
      migrations.map! {|e| e.scan(/\d+(?=_)/).first.to_i }.sort!
      if migration_number && migrations.include?(migration_number.to_i)
        return migration_number.to_i
      else
        return migrations.last
      end
    end

    def fixtures
      files = Dir.glob(@options[:fixtures_path] + '/*.yml')
      files.each do |f|
        puts f
      end
    end

    private
    def load_model(name)
      require File.join(FoodDB[:root], 'model', name)
    end

    public
    def load_models
      %w(food user scan scanner).each {|model| load_model model }
    end

    def connect
      FoodDB[:db] = Sequel.connect DatabaseConfig.sequel_string, :loggers => FoodDB[:logger]
      FoodDB[:logger].info "Using #{FoodDB::DatabaseConfig.env} as database."
    end
  end
end

require File.join(FoodDB[:root], 'lib/database_config')
FoodDB::DatabaseConfig.load_config
FoodDB::DatabaseConfig.env = 'development'
