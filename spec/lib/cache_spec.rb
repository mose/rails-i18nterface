# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::Cache do
  include RailsI18nterface::Cache

  before :each do
    @cachefile = File.expand_path(File.join('..', 'files', 'cache_test'), __FILE__)
  end

  after :each do
    FileUtils.rm @cachefile if File.exists? @cachefile
  end

  it 'stores cache of an object' do
    a = { a: 'a' }
    cache_save a, @cachefile
    File.exists?(@cachefile).should be_true
  end

  it 'reads cache from marshalled file' do
    a = { a: 'a' }
    cache_save a, @cachefile
    b = cache_load @cachefile
    b.should == a
  end

  it 'creates the cache if not present' do
    b = cache_load @cachefile do
      20
    end
    File.exists?(@cachefile).should be_true
    b.should == 20
  end

  it 'creates the cache if not present, using an argument' do
    b = cache_load @cachefile, 'something' do |options|
      options
    end
    File.exists?(@cachefile).should be_true
    b.should == 'something'
  end



end