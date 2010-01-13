require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe "The Website" do

  def app
    App
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end

  it "should respond to /about" do
    get '/about'
    last_response.should be_ok
  end

  it "should respond to /signup" do
    get '/signup'
    last_response.should be_ok
  end

  it "should get redirected on visiting user page when not logged in" do
    get '/user'
    last_response.status.should == 302
  end

  it "should login succuessfully" do
    post '/user/login', :username => "abird", :password => "asdfasdf"
    last_response.status.should == 302
    last_response.headers['location'].should == '/user'
    follow_redirect!
    last_response.should be_ok
  end
end
