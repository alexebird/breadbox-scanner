require 'rubygems'
require 'scan-server/server'
require 'kernel'

frid = ScanServer::Server.new('0.0.0.0', 5000)
frid.start
