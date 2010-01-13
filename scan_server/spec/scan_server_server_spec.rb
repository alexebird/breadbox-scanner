require 'scan_server/server'

# stupid test:
#describe ScanServer::Server do
  #before(:all) do
    #ScanServer.logger = Logger.new('/dev/null')
  #end

  #it "should run then shutdown." do
    #lambda {
      #pid = fork {
        #f = ScanServer::Server.new
        #f.start
      #}
      #sleep 2
      #Process.kill("TERM", pid)
    #}.should_not raise_error
  #end
#end
