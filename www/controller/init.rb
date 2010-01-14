# Define a subclass of Ramaze::Controller holding your defaults for all
# controllers

class Controller < Ramaze::Controller
  layout :default
  helper :blue_form
  helper :flash
  helper :xhtml
  helper :link
  helper :render
  engine :Etanni
end

# Here go your requires for subclasses of Controller:
require __DIR__('main')
require __DIR__('user')
