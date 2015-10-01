# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::Sourcefiles do

  let(:root_dir) { File.expand_path(File.join('..', '..', '..', 'spec', 'internal'), __FILE__) }
  let(:cache_file) { File.join(root_dir, 'tmp', 'translation_strings') }

  after { FileUtils.rm cache_file if File.exists? cache_file}

  describe '.hash' do
    let(:expected) { {
      'activerecord.models.article' => ['db/schema.rb'],
      'activerecord.attributes.article.title' => ['db/schema.rb'],
      'activerecord.attributes.article.body' => ['db/schema.rb'],
      'activerecord.attributes.article.created_at' => ['db/schema.rb'],
      'activerecord.attributes.article.updated_at' => ['db/schema.rb'],
      'activerecord.attributes.article.active' => ['db/schema.rb'],
      'activerecord.models.topic' => ['db/schema.rb'],
      'activerecord.attributes.topic.title' => ['db/schema.rb'],
      'activerecord.attributes.topic.created_at' => ['db/schema.rb'],
      'activerecord.attributes.topic.updated_at' => ['db/schema.rb']
    } }
    let(:hash) { RailsI18nterface::Sourcefiles.extract_activerecords(root_dir) }
    it 'grabs field from schema.rb' do
      expect(hash).to eq expected
    end
  end

  describe '.allfiles' do
    before { @allfiles = RailsI18nterface::Sourcefiles.load_files(root_dir) }
    it 'extracts translatable string from code source' do
      expect(File.exists? cache_file).to be_truthy
      expect(@allfiles['title']).to eq ['app/controllers/application_controller.rb']
    end
  end

  describe '.keys' do
    let(:file) { File.join(root_dir, 'app/models/article.rb') }
    let(:keys) { RailsI18nterface::Sourcefiles.populate_keys(root_dir, file) }
    it 'populates from plural form when a :count is passed as param' do
      expect(keys[:'article.key3.zero']).to be_nil
      expect(keys[:'article.key4.zero']).to eq ['app/models/article.rb']
      expect(keys[:'article.key4.one']).to eq ['app/models/article.rb']
      expect(keys[:'article.key4.other']).to eq ['app/models/article.rb']
    end
    it 'populates from plural form when a :count => is passed as param' do
      expect(keys[:'article.key6.zero']).to eq ['app/models/article.rb']
      expect(keys[:'article.key6.one']).to eq ['app/models/article.rb']
      expect(keys[:'article.key6.other']).to eq ['app/models/article.rb']
    end
  end

  describe 'refreshing' do
    let(:testfile) { File.join(root_dir, 'app', 'views', 'test.html.erb') }
    
    before do
      RailsI18nterface::Sourcefiles.load_files(root_dir)
      File.open(File.join(root_dir, 'app', 'views', 'test.html.erb'),'w') do |f|
        f.puts "<%= t('something') %>"
      end
      @allfiles = RailsI18nterface::Sourcefiles.refresh(root_dir)
    end

    after do
      FileUtils.rm testfile if File.exists? testfile
      FileUtils.rm cache_file if File.exists? cache_file
    end

    it 'refreshes translatable strings cache' do
      expect(@allfiles['something']).to eq ['app/views/test.html.erb']
    end
  end

end
