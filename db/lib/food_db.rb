require 'rubygems'
require 'sequel'
require 'logger'

module FoodDB
  @options = Hash.new
  @options[:root] = ENV['DB_ROOT']
  @options[:fixtures_path] = File.join(@options[:root], 'fixtures')
  @options[:migations_path] = File.join(@options[:root], 'migrations')

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
      fxts = {}
      files.each do |f|
        fixture = f.match(/^\/.*\/(.+)\.yml$/)[1].to_sym
        fxts[fixture] = f
      end

      return fxts
    end

    private
    def load_model(name)
      require File.join(FoodDB[:root], 'model', name)
    end

    def load_models
      %w(food user scan scanner).each {|model| load_model model }
    end

    public
    def connect(options={})
      if options
        if options[:log_to_console]
          logger = Logger.new(STDOUT)
        end
      end

      FoodDB[:db] = Sequel.connect DatabaseConfig.sequel_string
      FoodDB[:db].loggers << logger if logger
      FoodDB[:db].log_info "Using #{FoodDB::DatabaseConfig.env} as database."
      load_models
    end
  end
end

require File.join(FoodDB[:root], 'lib/database_config')
FoodDB::DatabaseConfig.load_config
FoodDB::DatabaseConfig.env = 'development' unless FoodDB::DatabaseConfig.env
