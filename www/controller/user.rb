require 'digest/sha2'

class UserController < Controller
  map '/user'

  def index
    if session[:user]
      @user = session[:user]
    else
      flash[:message] = "Must be logged into view this page."
      redirect "/"
    end
  end

  def login
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

  def logout
    session[:user] = nil
    redirect "/"
  end

  def create
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
      flash[:message] = "Password fields do not match."
      redirect "/signup"
    end
  end

  private
  def user_exists?(name, email)
    return !User[:username => request[:username]].nil? || !User[:email => request[:email]].nil?
  end

  def passwords_match?(p1, p2)
    return p1 == p2
  end
end
