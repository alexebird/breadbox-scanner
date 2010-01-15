require File.join(File.dirname(__FILE__), '../lib/scan_server/request')

describe ScanServer::Request do
  it "should strip http post header from request" do
    request = "POST / HTTP/1.0\r\nHost: everest\r\nUser-Agent: WiServer/1.1\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 14  \r\n\r\nHello world!\r\n"
    ScanServer::Request.strip_post_header(request).should == "Hello world!"
  end
end
