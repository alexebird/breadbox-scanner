require 'rubygems'
require 'sinatra/base'
require 'digest/sha2'
require 'haml'
require 'sass'
require 'rack-flash'
require '../db/init'

class App < Sinatra::Base
  enable :sessions, :run, :logging
  FoodDB.connect
  FoodDB.load_models

  use Rack::Flash

  get '/' do
    haml :index
  end

  get '/about' do
    haml :about
  end

  get '/signup' do
    haml :signup
  end

  get '/user' do
    if session[:user]
      @user = session[:user]
      haml :"user/index"
    else
      flash[:message] = "Must be logged into view this page."
      redirect "/"
    end
  end

  post '/user/login' do
    digest = Digest::SHA2.new << request[:password]
    @user = User[:username => request[:username], :password => digest.to_s]

    if @user
      session[:user] = @user
      redirect "/user"
    else
      flash[:login_message] = "User not found."
      redirect "/"
    end
  end

  get '/user/logout' do
    session[:user] = nil
    redirect "/"
  end

  post '/user/create' do
    if user_exists?(request[:name], request[:email])
      flash[:message] = "Username or email already has an account."
      redirect "/signup"
    elsif passwords_match?(request[:password], request[:password_confirm])
      @user = User.create(:username => request[:username],
                          :password => (Digest::SHA2.new << request[:password]).to_s,
                          :name => request[:name],
                          :email => request[:email])
      session[:user] = @user
      redirect "/user"
    else
      flash[:message] = "Password fields do not match"
      redirect "/signup"
    end
  end

  helpers do
    def user_exists?(name, email)
      return !User[:username => request[:username]].nil? || !User[:email => request[:email]].nil?
    end

    def passwords_match?(p1, p2)
      return p1 == p2
    end
  end
end
