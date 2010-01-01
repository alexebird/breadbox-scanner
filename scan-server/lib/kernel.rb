module Kernel
  def debug(msg)
    Frid.logger.debug msg if Frid.logger
  end

  def info(msg)
    Frid.logger.info msg if Frid.logger
  end
  
  def warn(msg)
    Frid.logger.warn msg if Frid.logger
  end

  def error(msg)
    Frid.logger.error msg if Frid.logger
  end

  def fatal(msg)
    Frid.logger.fatal msg if Frid.logger
  end
end
