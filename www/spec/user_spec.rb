describe UserController do
  it_should_behave_like RamazeTest

  it "should get redirected on visiting user page when not logged in" do
    get '/user'
    last_response.status.should == 302
  end

  it "should log known user in succuessfully" do
    post '/user/login', :username => "abird", :password => "asdfasdf"
    last_response.status.should == 302
    follow_redirect!
    last_response.status.should == 200
  end

  it "should fail to create a user when name or email is already used" do
    post '/user/create', :name => "Dave Thomas", :username => "dtom",
      :password => "asdfasdf", :email => "dave@wendys.com", :password_confirm => "asdfasdf"
    last_response.status.should == 302
    follow_redirect!
    last_response.status.should == 200
    last_response.body.should =~ /.*Problem:*/
  end

  it "should fail to create a user when passwords do not match" do
    post '/user/create', :name => "Dave Thomas", :username => "asdf",
      :password => "asdfasdf", :email => "asdf@asdf.com", :password_confirm => "asdf"
    last_response.status.should == 302
    follow_redirect!
    last_response.status.should == 200
    last_response.body.should =~ /.*Problem: passwords do not match.*/
  end

  it "should log user in and show user index after successful account creation" do
    post '/user/create', :name => "Alvin T Smiley", :username => "asmlyee",
      :password => "asdfasdf", :email => "a@tomtom.com", :password_confirm => "asdfasdf"
    last_response.status.should == 302
    follow_redirect!
    last_response.status.should == 200
    last_response.body.should =~ /.*Welcome, Alvin T Smiley\..*/
  end
end
