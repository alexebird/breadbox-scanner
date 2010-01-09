require 'rubygems'
require 'scan_server/server'

frid = ScanServer::Server.new('0.0.0.0', 5000)
frid.start
