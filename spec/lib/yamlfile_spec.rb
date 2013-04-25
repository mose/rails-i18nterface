# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::Yamlfile do

  include RailsI18nterface::Utils

  before :each do
    @translations = { en: { a: { aa: 'aa' }, b: 'b' } }
  end

  describe 'write' do
    before(:each) do
      @root_dir = File.expand_path(File.join('..', '..', '..', 'spec', 'internal'), __FILE__)
      @file_path = File.join(@root_dir, 'config', 'locales', 'en.yml')
      @file = RailsI18nterface::Yamlfile.new(@root_dir, :en)
    end

    after(:each) do
      FileUtils.rm(@file_path) if File.exists? @file_path
    end

    it 'writes all I18n messages for a locale to YAML file' do
      @file.write(@translations)
      @file.read.should == deep_stringify_keys(@translations)
    end

  end

  describe 'deep_stringify_keys' do
    it 'should convert all keys in a hash to strings' do
      expected = { 'en' => { 'a' => { 'aa' => 'aa' }, 'b' => 'b' } }
      deep_stringify_keys(@translations).should == expected
    end
  end

end
