require 'ramaze'
require 'ramaze/spec/bacon'

require __DIR__('../app')

describe UserController do
  behaves_like :rack_test


  should "get redirected on visiting user page when not logged in" do
    get '/user'
    last_response.status.should == 302
  end

  should "login succuessfully" do
    post '/user/login', :username => "abird", :password => "asdfasdf"
    last_response.status.should == 302
    follow_redirect!
    last_response.status.should == 200
  end

  should "fail to create a user when name or email is already used" do
    post '/user/create', :name => "Dave Thomas", :username => "dtom",
      :password => "asdfasdf", :email => "dave@wendys.com", :password_confirm => "asdfasdf"
    last_response.status.should == 302
    follow_redirect!
    last_response.status.should == 200
    puts last_response.body
    #last_response.body.should =~ /.*Username or email already has an account.*/
  end

  #should "fail to create a user when passwords do not match" do
    #post '/user/create', :name => "Dave Thomas", :username => "asdf",
      #:password => "asdfasdf", :email => "asdf@asdf.com", :password_confirm => "asdf"
    #last_response.status.should == 302
    #follow_redirect!
    #last_response.should be_ok
    #last_response.body.should include("Password fields do not match")
  #end

  #should "log user in and show user index after successful account creation" do
    #post '/user/create', :name => "Alvin T Smiley", :username => "asmlyee",
      #:password => "asdfasdf", :email => "a@tomtom.com", :password_confirm => "asdfasdf"
    #last_response.status.should == 302
    #last_response.headers['location'].should == '/user'
    #follow_redirect!
    #last_response.should be_ok
    #last_response.body.should include("Alvin")
  #end
end
