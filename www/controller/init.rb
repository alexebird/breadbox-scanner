# Define a subclass of Ramaze::Controller holding your defaults for all
# controllers

class Controller < Ramaze::Controller
  layout :unsecure
  helper :blue_form
  helper :flash
  helper :xhtml
  helper :link
  helper :render
  engine :Etanni

  def session_user
    if session[:user]
      return session[:user].refresh
    else
      flash[:message] = "Must be logged into view this page."
      redirect MainController.r
    end
  end
end

# Here go your requires for subclasses of Controller:
require __DIR__('food')
require __DIR__('inventory')
require __DIR__('main')
require __DIR__('scan')
require __DIR__('user')
