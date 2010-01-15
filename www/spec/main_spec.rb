describe MainController do
  it_should_behave_like RamazeTest

  it "should show start page" do
    get('/').status.should == 200
    last_response['Content-Type'].should == 'text/html'
    last_response.body.should =~ /.*Personal Food Inventory.*/
  end

  it "should respond to /about" do
    get('/about').status.should == 200
  end

  it "should respond to /signup" do
    get('/signup').status.should == 200
  end
end
