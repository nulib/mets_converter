require 'logger'

module MetsConverter
  module Logging
    def self.initialize_logger(log_target = STDOUT)
      oldlogger = defined?(@logger) ? @logger : nil
      @logger = Logger.new(log_target)
      @logger.level = Logger::INFO
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
      oldlogger.close if oldlogger
      @logger
    end

    def self.logger
      defined?(@logger) ? @logger : initialize_logger
    end

    def self.logger=(log)
      @logger = (log ? log : MetsConverter::Logging.logger.new(File::NULL))
    end

    def logger
      MetsConverter::Logging.logger
    end
  end
end
