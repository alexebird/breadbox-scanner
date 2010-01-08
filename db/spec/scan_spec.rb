describe Scan do
  it "should automatically set the timestamp" do
    s = Scan.create(:scanner => Scanner.first, :food => Food.first)
    s.timestamp.should_not == nil
  end
end
