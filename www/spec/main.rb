require 'ramaze'
require 'ramaze/spec/bacon'

require __DIR__('../app')

describe MainController do
  behaves_like :rack_test

  should 'show start page' do
    get('/').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.body.should =~ /.*Personal Food Inventory.*/
  end

  should "respond to /about" do
    get('/about').status.should == 200
  end

  should "respond to /signup" do
    get('/signup').status.should == 200
  end
end
