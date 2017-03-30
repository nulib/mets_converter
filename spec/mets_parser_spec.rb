RSpec.describe MetsParser do
  subject(:mets) { described_class.new('spec/fixtures/35556002332765.mets.xml') }

  describe '#initialize' do
    it 'creates a Nokogiri XML document' do
      expect(mets.document.class).to eq(Nokogiri::XML::Document)
    end
  end

  describe '#capture_date' do
    it 'extracts the capture date from the header' do
      expect(mets.capture_date).to eq '2015-09-03T14:28:35-06:00'
    end
  end

  describe '#input_file_location' do
    it 'returns the input file path' do
      expect(mets.input_file_location).to eq 'spec/fixtures'
    end
  end

  describe '#pages' do
    it 'creates a Nokogiri NodeSet' do
      expect(mets.pages.class).to eq(Nokogiri::XML::NodeSet)
    end

    it 'extracts the correct number of page elements from the mets file' do
      expect(mets.pages.length).to eq(268)
    end
  end
end
