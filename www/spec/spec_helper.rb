require File.join(File.dirname(__FILE__), '..', 'app.rb')

require 'rubygems'
#require 'sinatra'
require 'rack/test'
require 'rack/flash/test'
require 'spec'
#require 'spec/autorun'
#require 'spec/interop/test'

# set test environment
App.set :environment, :test
App.set :run, false
App.set :raise_errors, true
App.set :logging, false

Spec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
end
