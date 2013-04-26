# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::Sourcefiles do

  before :each do
    @root_dir = File.expand_path(File.join('..', '..', '..', 'spec', 'internal'), __FILE__)
    @cache_file = File.join(@root_dir, 'tmp', 'translation_strings')
    FileUtils.rm @cache_file if File.exists? @cache_file
  end

  it 'grabs field from schema.rb' do
    expected = {
      'activerecord.models.article'=>['db/schema.rb'],
      'activerecord.attributes.article.title'=>['db/schema.rb'],
      'activerecord.attributes.article.body'=>['db/schema.rb'],
      'activerecord.attributes.article.created_at'=>['db/schema.rb'],
      'activerecord.attributes.article.updated_at'=>['db/schema.rb'],
      'activerecord.attributes.article.active'=>['db/schema.rb'],
      'activerecord.models.topic'=>['db/schema.rb'],
      'activerecord.attributes.topic.title'=>['db/schema.rb'],
      'activerecord.attributes.topic.created_at'=>['db/schema.rb'],
      'activerecord.attributes.topic.updated_at'=>['db/schema.rb']
    }
    hash = RailsI18nterface::Sourcefiles.extract_activerecords(@root_dir)
    hash.should == expected
  end

  it 'extracts translatable string from code source' do
    x = RailsI18nterface::Sourcefiles.load_files(@root_dir)
    File.exists?(@cache_file).should be_true
    x.size.should == 19
  end

  describe 'refreshing' do
    before :each do
      RailsI18nterface::Sourcefiles.load_files(@root_dir)
      @testfile = File.join(@root_dir,'app','views','test.html.erb')
    end

    after :each do
      FileUtils.rm @testfile if File.exists? @testfile
      FileUtils.rm @cache_file if File.exists? @cache_file
    end

    it 'refreshes translatable strings cache' do
      File.open(File.join(@root_dir,'app','views','test.html.erb'),'w') do |f|
        f.puts "<%= t('something') %>"
      end
      y = RailsI18nterface::Sourcefiles.refresh(@root_dir)
      y.size.should == 20
    end
  end

end