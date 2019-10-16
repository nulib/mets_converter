require 'spec_helper'

RSpec.describe MetsConverter::YamlBuilder do
  subject(:mets) { MetsConverter::MetsParser.new('spec/fixtures/35556002332765.mets.xml') }
  subject(:opts) { {suprascan: true, resolution: "2000", scanning_order_rtl: true, reading_order_rtl: true} }
  subject(:builder) { described_class.new(mets) }
  subject(:builder_with_options) { described_class.new(mets, opts) }

  it { is_expected.to respond_to(:document) }
  it { is_expected.to respond_to(:pages) }
  it { is_expected.to respond_to(:options) }

  context 'builds a yaml with default values' do
    describe '#build' do
      it 'outputs yaml' do
        expect(builder.build).to eq(File.read('spec/fixtures/test.yml'))
      end
    end
  end

  context 'defaults can be overriden with options' do
    describe '#build' do
      it 'outputs yaml' do
        expect(builder_with_options.build).to eq(File.read('spec/fixtures/test_with_options.yml'))
      end
    end
  end
end
