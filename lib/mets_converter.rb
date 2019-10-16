require 'mets_converter/mets_parser'
require 'mets_converter/version'
require 'mets_converter/yaml_builder'

module MetsConverter #:nodoc:
  def self.logger
    MetsConverter::Logging.logger
  end

  def self.logger=(log)
    MetsConverter::Logging.logger = log
  end
end
