module Kernel
  def debug(msg)
    ScanServer.logger.debug msg if ScanServer.logger
  end

  def info(msg)
    ScanServer.logger.info msg if ScanServer.logger
  end
  
  def warn(msg)
    ScanServer.logger.warn msg if ScanServer.logger
  end

  def error(msg)
    ScanServer.logger.error msg if ScanServer.logger
  end

  def fatal(msg)
    ScanServer.logger.fatal msg if ScanServer.logger
  end
end
