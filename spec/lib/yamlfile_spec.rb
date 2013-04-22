require 'spec_helper'

describe RailsI18nterface::Yamlfile do

  before :each do
    @translations = { en: { a: { aa: 'aa' }, b: 'b' } }
  end

  describe 'write' do
    before(:each) do
      @file_path = File.join(File.dirname(__FILE__), 'files', 'en.yml')
      @file = RailsI18nterface::Yamlfile.new(@file_path)
    end

    after(:each) do
      FileUtils.rm(@file_path)
    end

    it 'writes all I18n messages for a locale to YAML file' do
      @file.write(@translations)
      @file.read.should == RailsI18nterface::Yamlfile.new(nil).deep_stringify_keys(@translations)
    end

  end

  describe 'deep_stringify_keys' do
    it 'should convert all keys in a hash to strings' do
      expected = { 'en' => { 'a' => { 'aa' => 'aa' }, 'b' => 'b' } }
      RailsI18nterface::Yamlfile.new(nil).deep_stringify_keys(@translations).should == expected
    end
  end

end
