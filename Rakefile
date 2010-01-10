require 'rubygems'
require 'rake'
import 'db/db.rake'

namespace :run do
  desc "Run the server which listens for RFID scans."
  task :server do
    sh "ruby -C scan_server init.rb"
  end

  desc "Run the web server."
  task :www do
    sh "ruby -C www start.rb"
  end

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
desc "Generate all rdocs."
task :doc => ['doc:readme']

namespace :test do
  task :setup_test_db do
    ENV['DB_ENV'] = 'test'
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:pop'].invoke
  end

  desc "Run all scan server tests."
  task :scanserver do
    cd "scan_server" do
      sh "spec --format specdoc -c spec/"
    end
  end

  namespace :scanserver do 
    desc "Run the time in words methods."
    task :time do
      cd "scan_server" do
        sh "spec --format specdoc -c spec/time_diff_in_words_spec.rb"
      end
    end
  end

  desc "Run all model tests."
  task :model => :setup_test_db do
    cd "db" do
      sh "spec -r init --format specdoc -c spec/"
    end
  end
end
desc "Run all tests."
task :test => ['test:scanserver', 'test:model']
