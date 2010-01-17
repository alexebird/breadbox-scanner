describe FoodController do
  it_should_behave_like RamazeTest

  before(:all) do
    post '/user/login', :username => "abird", :password => "asdfasdf"
  end

  it "should allow valid food to be created" do
    post '/food/create', :name => "Cookies", :rfid => "393kdidk93", :room => 10, :fridge => 21, :freezer => 40
    last_response.status.should == 302
    follow_redirect!
    last_response.status.should == 200
    doc = Hpricot(last_response.body)
    (doc/"p#food-message").inner_html.should == "Cookies has been created"
  end
end
