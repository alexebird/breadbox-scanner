describe User do
  it "scan_food() should toggle inclusion of a food" do
    u = User.first
    f = Food.first
    u.scan_food(f)
    u.foods.should include(f)
    u.scan_food(f)
    u.foods.should_not include(f)
  end
end
