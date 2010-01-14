require 'rubygems'
require 'rake'

namespace :test do
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
end
