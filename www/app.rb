require 'rubygems'
require 'sinatra/base'
require 'digest/sha2'
require 'haml'
require 'sass'
require '../db/init'

class App < Sinatra::Base
  enable :sessions, :run, :logging
  FoodDB.connect
  FoodDB.load_models

  get '/' do
    haml :index
  end

  get '/user' do
    @user = session[:user]
    haml :"user/index"
  end

  post '/user/login' do
    digest = Digest::SHA2.new << request[:password]
    @user = User[:username => request[:username], :password => digest.to_s]

    puts @user.inspect
    if @user
      session[:user] = @user
      redirect '/user/index'
    else
      flash[:message] = "user not found."
      redirect '/main/index'
    end
  end
end
