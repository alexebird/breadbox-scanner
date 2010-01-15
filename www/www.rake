require 'rubygems'
require 'rake'
require 'spec'

WWW_ROOT = File.expand_path(File.dirname(__FILE__))

namespace :test do
  namespace :www do
    desc "Test MainController."
    FoodHelpers::FoodSpecTask.new(WWW_ROOT, :main => ['db:beforetest']) do |t|
      t.spec_files = "spec/main_spec.rb"
    end

    desc "Test UserController."
    FoodHelpers::FoodSpecTask.new(WWW_ROOT, :user => ['db:beforetest']) do |t|
      t.spec_files = "spec/user_spec.rb"
    end
  end

  desc "Run all website tests."
  task :www => ['www:main', 'www:user']
end

namespace :run do

  desc "Run the web server."
  task :www do
    sh "ruby -C #{WWW_ROOT} start.rb"
  end
end
