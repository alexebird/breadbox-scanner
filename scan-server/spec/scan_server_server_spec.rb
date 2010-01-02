require 'scan-server/server'

describe ScanServer::Server do
  before(:all) do
    ScanServer.logger = nil
  end

  it "should run then shutdown." do
    lambda {
      pid = fork {
        f = ScanServer::Server.new
        f.start
      }
      sleep 2
      Process.kill("TERM", pid)
    }.should_not raise_error
  end
end

#def ScanServer.send_arduino(cmd)
  #host, port = 'localhost', 5248
  #TCPSocket.open(host, port) do |s|
    #puts " sending: #{cmd}"
    #s.puts cmd
    #while line = s.gets
      #line.chomp!
      #puts "response: #{line}"
    #end
  #end
#end
