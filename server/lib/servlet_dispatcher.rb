module Frid
  class ServletDispatcher
    def initialize
      @servlets = nil
      load_servlets
    end
    
    def dispatch(request)
      @servlets[request.name].do_command(request) if @servlets[request.name]
    end

    private

    def load_servlets
      @servlets = {}
      Dir.glob("#{APP_ROOT}/lib/servlets/*_servlet.rb").each do |servlet|
        load_servlet servlet
      end
    end

    def load_servlet(servlet)
      Frid.logger.info "Loading servlet: #{servlet}."
      require servlet
      classname = File.basename(servlet).scan(/\w+(?=_servlet\.rb)/).first
      fullname = "#{classname.capitalize!}Servlet"
      @servlets[classname.downcase!] = Frid.const_get(fullname).new
    end
  end
end
