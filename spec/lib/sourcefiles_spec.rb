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
    expect(hash).to eq expected
  end

  it 'extracts translatable string from code source' do
    allfiles = RailsI18nterface::Sourcefiles.load_files(@root_dir)
    expect(File.exists? @cache_file).to be_true
    expect(allfiles['title']).to eq ['app/controllers/application_controller.rb']
  end

  it 'populates from plural form when a :count is passed as param' do
    file = File.join(@root_dir, 'app/models/article.rb')
    keys = RailsI18nterface::Sourcefiles.populate_keys(@root_dir, file)
    expect(keys[:"article.key3.zero"]).to be_nil
    expect(keys[:"article.key4.zero"]).to eq ["app/models/article.rb"]
    expect(keys[:"article.key4.one"]).to eq ["app/models/article.rb"]
    expect(keys[:"article.key4.other"]).to eq ["app/models/article.rb"]
  end

  it 'populates from plural form when a :count => is passed as param' do
    file = File.join(@root_dir, 'app/models/article.rb')
    keys = RailsI18nterface::Sourcefiles.populate_keys(@root_dir, file)
    expect(keys[:"article.key6.zero"]).to eq ["app/models/article.rb"]
    expect(keys[:"article.key6.one"]).to eq ["app/models/article.rb"]
    expect(keys[:"article.key6.other"]).to eq ["app/models/article.rb"]
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
      allfiles = RailsI18nterface::Sourcefiles.refresh(@root_dir)
      expect(allfiles['something']).to eq ['app/views/test.html.erb']
    end
  end

end