require 'nokogiri'

class MetsParser
  attr_reader :document

  def initialize(file)
    @file = file
    @document = parse_xml
  end

  def input_file_location
    File.dirname(@file)
  end

  def capture_date
    document.xpath('//xmlns:metsHdr')[0].attr('CREATEDATE') + '-06:00'
  end

  def pages
    document.search('structMap[@TYPE="logical"]//div[@TYPE="page"]')
  end

  private

  def parse_xml
    input_file = File.open(@file)
    begin
      xsd = Nokogiri::XML::Schema(File.open('xsd/mets.xsd'))
      doc = Nokogiri::XML(input_file, &:strict)
      xsd.valid?(doc) ? doc : raise('Invalid METS file')
    rescue Nokogiri::XML::SyntaxError => e
      MetsConverter.logger.error "XML error: #{e}"
    end
  end
end
