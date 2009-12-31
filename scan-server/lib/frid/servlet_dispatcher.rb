require 'frid/servlet'

module Frid
  class ServletDispatcher
    def initialize
      @servlets = nil
      load_servlets
    end
    
    def dispatch(request)
      @servlets['rfid'].do_command(request) if @servlets['rfid']
    end

    private

    def load_servlets
      @servlets = {}
      Dir.glob("servlets/*_servlet.rb").each do |servlet|
        load_servlet servlet
      end
    end

    def load_servlet(servlet)
      info "Loading servlet: #{servlet}."
      require servlet
      classname = File.basename(servlet).scan(/\w+(?=_servlet\.rb)/).first
      fullname = "#{classname.capitalize!}Servlet"
      @servlets[classname.downcase!] = Frid.const_get(fullname).new
    end
  end
end
