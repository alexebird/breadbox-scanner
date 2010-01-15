require 'rubygems'
require 'rake'

SCAN_SERVER_ROOT = File.expand_path(File.dirname(__FILE__))

namespace :test do
  desc "Run all scan server tests."
  FoodHelpers::FoodSpecTask.new(SCAN_SERVER_ROOT, :scanserver) do |t|
    t.spec_files = "spec/"
  end
end

namespace :run do
  desc "Run the server which listens for RFID scans."
  task :server do
    sh "ruby -C scan_server init.rb"
  end
end
