require 'rubygems'
require 'rack/test'

require File.join(File.dirname(__FILE__), '../app')

module Innate
  # minimal middleware, no exception handling
  middleware(:spec){|mw| mw.innate }
  # skip starting adapter
  options.started = true
  options.mode = :spec
end

Ramaze.middleware!(:spec) do |m|
  m.run(Ramaze::AppMap)
end
 
share_as :RamazeTest do
  Ramaze.setup_dependencies
  #extend Rack::Test::Methods
  include Rack::Test::Methods

  def app; Ramaze.middleware; end
end
