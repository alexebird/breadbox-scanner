require 'frid/server'

describe Frid::Server do
  before(:all) do
    Frid.logger = nil
  end

  it "should run then shutdown." do
    lambda {
      pid = fork {
        f = Frid::Server.new
        f.start
      }
      sleep 2
      Process.kill("TERM", pid)
    }.should_not raise_error
  end
end

#def Frid.send_arduino(cmd)
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
