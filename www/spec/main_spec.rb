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

describe MainController do
  it_should_behave_like RamazeTest

  it "should show start page" do
    get('/').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.body.should =~ /.*Personal Food Inventory.*/
  end

  it "should respond to /about" do
    get('/about').status.should == 200
  end

  it "should respond to /signup" do
    get('/signup').status.should == 200
  end
end
