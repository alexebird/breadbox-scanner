class UserController < Controller
  layout :secure
  helper :user_helper

  def index
    @user = session_user
    scanner = @user.scanners.first
    @user.inventory.each do |food|
      time, location = food.time_and_location_for(scanner)
      food.set(:expires => time, :location => location)
    end
  end

  def login
    @user = User.find_login(request[:username], request[:password])

    if @user
      session[:user] = @user
      redirect UserController.r
    else
      flash[:message] = "User not found."
      redirect MainController.r
    end
  end

  def logout
    session[:user] = nil
    redirect MainController.r
  end

  def create
    if password_confirmed? request[:password], request[:password_confirm]
      @user = User.new(:username => request[:username],
                       :password => request[:password],
                       :name => request[:name],
                       :email => request[:email])

      if @user.save
        session[:user] = @user
        redirect UserController.r
      else
        flash[:message] = "Problem: #{@user.errors.full_messages.first}."
        redirect MainController.r(:signup)
      end
    else
      flash[:message] = "Problem: passwords do not match."
      redirect MainController.r(:signup)
    end
  end

  def delete
    session[:user] = nil
    flash[:message] = "User has (not actually) been deleted."
    redirect MainController.r(:message)
  end

  private
  def password_confirmed?(p1, p2)
    return p1 == p2
  end
end
