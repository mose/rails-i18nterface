# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::Cache do
  include RailsI18nterface::Cache

  before :each do
    @cachefile = File.expand_path(File.join('..', 'files', 'cache_test'), __FILE__)
    @file = File.join(File.dirname(@cachefile), 'test.yml')
    @sample = { 'a' => 'a', 'b' => 'b' }
    File.open(@file, 'w') do |f|
      f.write YAML.dump(@sample)
    end
  end

  after :each do
    FileUtils.rm @cachefile if File.exists? @cachefile
    FileUtils.rm @file if File.exists? @file
  end

  it 'stores cache of an object' do
    a = { a: 'a' }
    cache_save a, @cachefile
    File.exists?(@cachefile).should be_true
  end

  it 'reads cache from marshalled file' do
    a = { a: 'a' }
    cache_save a, @cachefile
    b = cache_load @cachefile, @file
    b.should == a
  end

  it 'creates the cache if not present' do
    b = cache_load @cachefile, @file do
      YAML.load_file @file
    end
    b.should == @sample
  end

  it 'refreshes the cache if the origin file changed' do
    mtime = File.mtime(@file) - 100
    File.utime(mtime, mtime, @file)
    b = cache_load @cachefile, @file do
      YAML.load_file @file
    end
    b.should == @sample
  end

end