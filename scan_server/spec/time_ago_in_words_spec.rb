require 'scan_server'

describe "ScanServer#time_ago_in_words()" do
  it "should use minutes for time up to 45 minutes" do
    ScanServer.time_ago_in_words(Time.now - (60 * 0)).should == "a minute ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 1)).should == "a minute ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 2)).should == "2 minutes ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 3)).should == "3 minutes ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 44)).should == "44 minutes ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 45)).should == "45 minutes ago"
  end

  it "should use hours for time between 46 minutes and 23 hours" do
    ScanServer.time_ago_in_words(Time.now - (60 * 46)).should == "1 hour ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 47)).should == "1 hour ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 89)).should == "1 hour ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 90)).should == "2 hours ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 91)).should == "2 hours ago"
    ScanServer.time_ago_in_words(Time.now - (60 * (2 * 60 + 29))).should == "2 hours ago"
    ScanServer.time_ago_in_words(Time.now - (60 * (2 * 60 + 30))).should == "3 hours ago"
    ScanServer.time_ago_in_words(Time.now - (60 * (3 * 60 + 29))).should == "3 hours ago"
    ScanServer.time_ago_in_words(Time.now - (60 * (3 * 60 + 30))).should == "4 hours ago"
    ScanServer.time_ago_in_words(Time.now - (60 * (22 * 60))).should == "22 hours ago"
    ScanServer.time_ago_in_words(Time.now - (60 * (22 * 60 + 29))).should == "22 hours ago"
    ScanServer.time_ago_in_words(Time.now - (60 * (22 * 60 + 30))).should == "23 hours ago"
    ScanServer.time_ago_in_words(Time.now - (60 * (22 * 60 + 59))).should == "23 hours ago"
    ScanServer.time_ago_in_words(Time.now - (60 * (23 * 60))).should == "23 hours ago"
  end

  it "should use days for time between 23 hours and 6 days" do
    ScanServer.time_ago_in_words(Time.now - (60 * (23 * 60 + 1))).should == "1 day ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 1)).should == "1 day ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 2)).should == "2 days ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 3)).should == "3 days ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 6)).should == "6 days ago"
  end

  it "should use weeks for time between 7 days and 4 weeks" do
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 7)).should == "1 week ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 8)).should == "1 week ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 13)).should == "2 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 14)).should == "2 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 15)).should == "2 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 19)).should == "3 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 20)).should == "3 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 21)).should == "3 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 22)).should == "3 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 23)).should == "3 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 24)).should == "3 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 25)).should == "4 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 26)).should == "4 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 27)).should == "4 weeks ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 28)).should == "4 weeks ago"
  end

  it "should use months for time between 4 weeks and 11 months" do
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 29)).should == "1 month ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 30)).should == "1 month ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 45)).should == "1 month ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 46)).should == "2 months ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 75)).should == "2 months ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 76)).should == "2 months ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 77)).should == "3 months ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 334)).should == "11 months ago"
  end

  it "should use years for time greater than 11 months" do
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 335)).should == "1 year ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 548)).should == "2 years ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 549)).should == "2 years ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 910)).should == "2 years ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 911)).should == "2 years ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 912)).should == "2 years ago"
    ScanServer.time_ago_in_words(Time.now - (60 * 60 * 24 * 913)).should == "3 years ago"
  end
end
