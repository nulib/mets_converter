require 'mets_converter/version'
require 'mets_converter/mets_parser'

module MetsConverter #:nodoc:
  def self.logger
    MetsConverter::Logging.logger
  end

  def self.logger=(log)
    MetsConverter::Logging.logger = log
  end
end
