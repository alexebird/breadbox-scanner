describe Scan do
  it "should automatically create the timestamp" do
    s = Scan.new(:scanner => Scanner.first, :food => Food.first)
  end
end
