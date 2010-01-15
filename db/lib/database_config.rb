require 'yaml'

module FoodDB

  # Stores configurations of the different database environments.
  #
  class DatabaseConfig
    class << self
      def dev?
        env == 'development'
      end

      def test?
        env == 'test'
      end

      def prod?
        env == 'production'
      end

      def sqlite?
        curr_db[:adapter] == 'sqlite'
      end

      def sqlite_file
        if sqlite?
          return File.join(FoodDB[:root], curr_db[:database])
        else
          return ''
        end
      end

      def mysql?
        curr_db[:adapter] == 'mysql'
      end

      def env
        ENV['DB_ENV']
      end

      def env=(newenv)
        ENV['DB_ENV'] = newenv if @databases.keys.include? newenv.to_sym
      end

      def sequel_string
        if curr_db[:adapter] == 'sqlite'
          "%s://%s" % [curr_db[:adapter], File.join(FoodDB[:root], curr_db[:database])]
        elsif curr_db[:adapter] == 'mysql'
          "%s://%s:%s@%s/%s" % [curr_db[:adapter], curr_db[:username], curr_db[:password], curr_db[:host], curr_db[:database]]
        end
      end

      def load_config
        @databases = YAML::load(File.open(File.join(FoodDB[:root], 'config/database.yml')))
      end

      def mysql_args
        return unless mysql?
        [curr_db[:username], curr_db[:password], curr_db[:host], curr_db[:database]]
      end

      private
      def curr_db
        @databases[ENV['DB_ENV'].to_sym]
      end
    end

    private
    def initialize
      raise "#{self.class} is not instantiable."
    end
  end
end
