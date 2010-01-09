require 'scan_server'

describe "ScanServer#time_diff_in_words()" do
  before(:all) do
    @time = Time.now + 100
  end

  it "should use minutes for time up to 45 minutes" do
    ScanServer.time_diff_in_words(@time - (60 * 0), @time).should == "a minute"
    ScanServer.time_diff_in_words(@time - (60 * 1), @time).should == "a minute"
    ScanServer.time_diff_in_words(@time - (60 * 2), @time).should == "2 minutes"
    ScanServer.time_diff_in_words(@time - (60 * 3), @time).should == "3 minutes"
    ScanServer.time_diff_in_words(@time - (60 * 44), @time).should == "44 minutes"
    ScanServer.time_diff_in_words(@time - (60 * 45), @time).should == "45 minutes"
  end

  it "should use hours for time between 46 minutes and 23 hours" do
    ScanServer.time_diff_in_words(@time - (60 * 46), @time).should == "1 hour"
    ScanServer.time_diff_in_words(@time - (60 * 47), @time).should == "1 hour"
    ScanServer.time_diff_in_words(@time - (60 * 89), @time).should == "1 hour"
    ScanServer.time_diff_in_words(@time - (60 * 90), @time).should == "2 hours"
    ScanServer.time_diff_in_words(@time - (60 * 91), @time).should == "2 hours"
    ScanServer.time_diff_in_words(@time - (60 * (2 * 60 + 29)), @time).should == "2 hours"
    ScanServer.time_diff_in_words(@time - (60 * (2 * 60 + 30)), @time).should == "3 hours"
    ScanServer.time_diff_in_words(@time - (60 * (3 * 60 + 29)), @time).should == "3 hours"
    ScanServer.time_diff_in_words(@time - (60 * (3 * 60 + 30)), @time).should == "4 hours"
    ScanServer.time_diff_in_words(@time - (60 * (22 * 60)), @time).should == "22 hours"
    ScanServer.time_diff_in_words(@time - (60 * (22 * 60 + 29)), @time).should == "22 hours"
    ScanServer.time_diff_in_words(@time - (60 * (22 * 60 + 30)), @time).should == "23 hours"
    ScanServer.time_diff_in_words(@time - (60 * (22 * 60 + 59)), @time).should == "23 hours"
    ScanServer.time_diff_in_words(@time - (60 * (23 * 60)), @time).should == "23 hours"
  end

  it "should use days for time between 23 hours and 6 days" do
    ScanServer.time_diff_in_words(@time - (60 * (23 * 60 + 1)), @time).should == "1 day"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 1), @time).should == "1 day"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 2), @time).should == "2 days"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 3), @time).should == "3 days"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 6), @time).should == "6 days"
  end

  it "should use weeks for time between 7 days and 4 weeks" do
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 7), @time).should == "1 week"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 8), @time).should == "1 week"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 13), @time).should == "2 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 14), @time).should == "2 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 15), @time).should == "2 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 19), @time).should == "3 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 20), @time).should == "3 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 21), @time).should == "3 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 22), @time).should == "3 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 23), @time).should == "3 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 24), @time).should == "3 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 25), @time).should == "4 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 26), @time).should == "4 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 27), @time).should == "4 weeks"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 28), @time).should == "4 weeks"
  end

  it "should use months for time between 4 weeks and 11 months" do
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 29), @time).should == "1 month"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 30), @time).should == "1 month"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 45), @time).should == "1 month"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 46), @time).should == "2 months"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 75), @time).should == "2 months"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 76), @time).should == "2 months"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 77), @time).should == "3 months"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 334), @time).should == "11 months"
  end

  it "should use years for time greater than 11 months" do
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 335), @time).should == "1 year"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 548), @time).should == "2 years"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 549), @time).should == "2 years"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 910), @time).should == "2 years"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 911), @time).should == "2 years"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 912), @time).should == "2 years"
    ScanServer.time_diff_in_words(@time - (60 * 60 * 24 * 913), @time).should == "3 years"
  end
end