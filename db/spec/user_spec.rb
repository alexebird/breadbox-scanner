describe User do
  it "scan_food() should toggle inclusion of a food" do
    u = User.first
    f = Food.first
    u.scan_food(f)
    u.inventory.should include(f)
    u.scan_food(f)
    u.inventory.should_not include(f)
  end
end
