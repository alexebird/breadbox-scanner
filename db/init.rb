ENV['DB_ROOT'] = File.expand_path(File.dirname(__FILE__))
require File.join(ENV['DB_ROOT'], '../lib/food_helpers')
require File.join(ENV['DB_ROOT'], 'lib/food_db')
