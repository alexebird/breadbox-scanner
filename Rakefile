require 'rubygems'
require 'rake'

import 'db/db.rake'
import 'www/www.rake'
import 'scan_server/scan_server.rake'

TOPLEVEL_ROOT = File.expand_path(File.dirname(__FILE__))
require File.join(TOPLEVEL_ROOT, 'lib/food_spec_task')

namespace :run do
  desc "Run the mock arduino."
  task :scanner do
    sh "ruby -C scanner/mock mock_arduino.rb"
  end
end

namespace :doc do
  desc "Generate rdoc for the README."
  task :readme do
    sh "rdoc README"
  end
end

namespace :test do
  desc "Run tests on project top level stuff."
  FoodHelpers::FoodSpecTask.new(TOPLEVEL_ROOT, :toplevel) do |t|
    t.spec_files = "spec/"
  end
end

desc "Generate all rdocs."
task :doc => ['doc:readme']

desc "Run all tests."
task :test => ['test:scanserver', 'test:db', 'test:www', 'test:toplevel']

desc "Show all TODO, XXX, or FIXME reminders."
task :todo do
  sh "egrep -n 'TODO|XXX|FIXME' * */* */*/* */*/*/* */*/*/*/*"
end
