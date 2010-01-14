require 'rubygems'
require 'rake'

WWW_RAKE_ROOT = File.expand_path(File.dirname(__FILE__))

namespace :test do
  namespace :www do

    desc "Test UserController."
    task :user => ['test:db:setup'] do
      cd WWW_RAKE_ROOT do
        sh "bacon spec/user.rb"
      end
    end

    desc "Test MainController."
    task :main => ['test:db:setup'] do
      cd WWW_RAKE_ROOT do
        sh "bacon spec/main.rb"
      end
    end
  end

  desc "Run all website tests."
  task :www => ['www:main', 'www:user']
end

namespace :run do

  desc "Run the web server."
  task :www do
    sh "ruby -C #{WWW_RAKE_ROOT} start.rb"
  end
end
