class UserController < Controller
  layout :user

  def index
    if session[:user]
      @user = session[:user].refresh
      scanner = @user.scanners.first
      @user.inventory.each do |food|
        time, location = food.time_and_location_for(scanner)
        food.set(:expires => time, :location => location)
      end
    else
      flash[:message] = "Must be logged into view this page."
      redirect "/"
    end
  end

  def login
    @user = User.find_login(request[:username], request[:password])

    if @user
      session[:user] = @user
      redirect "/user"
    else
      flash[:message] = "User not found."
      redirect "/"
    end
  end

  def logout
    session[:user] = nil
    redirect "/"
  end

  def create
    if password_confirmed? request[:password], request[:password_confirm]
      @user = User.new(:username => request[:username],
                       :password => request[:password],
                       :name => request[:name],
                       :email => request[:email])

      if @user.save
        session[:user] = @user
        redirect "/user"
      else
        flash[:message] = "Problem: #{@user.errors.full_messages.first}."
        redirect "/signup"
      end
    else
      flash[:message] = "Problem: passwords do not match."
      redirect "/signup"
    end
  end

  def inventory
    if session[:user]
      @user = session[:user].refresh
    else
      flash[:message] = "Must be logged into view this page."
      redirect "/"
    end
  end

  def scans
    if session[:user]
      @user = session[:user].refresh
      @scans = []
      @user.scanners.each do |scanner|
        scanner.scans.each {|scan| @scans << scan}
      end
    else
      flash[:message] = "Must be logged into view this page."
      redirect "/"
    end
  end

  private
  def password_confirmed?(p1, p2)
    return p1 == p2
  end
end
