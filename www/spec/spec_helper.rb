require 'rubygems'
require 'rack/test'
require 'hpricot'

#puts File.expand_path(File.join(File.dirname(__FILE__), '..'))
require File.join(File.dirname(__FILE__), '../app')

# minimal middleware, no exception handling
Innate.middleware(:spec) {|mw| mw.innate }
# skip starting adapter
Innate.options.started = true
Innate.options.mode = :spec

Ramaze.middleware!(:spec) do |m|
  m.run(Ramaze::AppMap)
end
 
Ramaze.options.helpers_helper.paths << File.expand_path(File.join(File.dirname(__FILE__), '../..'))

share_as :RamazeTest do
  Ramaze.setup_dependencies
  include Rack::Test::Methods

  def app
    Ramaze.middleware
  end
end
