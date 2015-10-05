# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::Keys do
  include RailsI18nterface::Utils

  let(:root_dir) { File.expand_path(File.join('..', '..', '..', 'spec', 'internal'), __FILE__) }
  let(:keys) { RailsI18nterface::Keys.new(root_dir, :sv, :no) }

  describe '.files' do
    let(:expected) { [
      'activerecord.attributes.article.active',
      'activerecord.attributes.article.body',
      'activerecord.attributes.article.created_at',
      'activerecord.attributes.article.title',
      'activerecord.attributes.article.updated_at',
      'activerecord.attributes.topic.created_at',
      'activerecord.attributes.topic.title',
      'activerecord.attributes.topic.updated_at',
      'activerecord.models.article',
      'activerecord.models.topic',
      'article.key1',
      'article.key2',
      'article.key3',
      'article.key4.one',
      'article.key4.other',
      'article.key4.zero',
      'article.key5',
      'article.key6.one',
      'article.key6.other',
      'article.key6.zero',
      'category_html_erb.key1',
      'category_rhtml.key1',
      'js.alert',
      'title'
    ] }
    it 'extracts keys from I18n lookups in .rb, .html.erb, and .rhtml files' do
      expect(keys.files.keys.sort).to eq expected
    end
  end

  describe "sorts by keys" do
    #before { allow(keys).to receive(:lookup).with('en', 'article.key6.zero').and_return('xxx') }
    it { expect(keys.sort_keys.last).to eq 'title' }
  end

  describe "sorts by translation" do
    it { expect(keys.sort_keys('text').last).to eq 'time.pm' }
  end

  describe 'return a hash with I18n keys and file lists' do
    it { expect(keys.files[:'article.key3']).to eq ['app/models/article.rb'] }
  end

  describe 'reloads the translatable strings' do
    let(:size) { keys.all_keys.size }
    it { expect(keys.reload(root_dir).size).to be size }
  end

  describe 'i18n_keys' do
    before do
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    end

    describe 'should return all keys in the I18n backend translations hash' do
      before { allow(I18n.backend).to receive(:translations).and_return(translations) }
      it { expect(keys.i18n_keys :en).to eq ['articles.new.page_title', 'categories.flash.created', 'empty', 'home.about'] }
    end

    describe 'untranslated_keys' do
      let(:expected) {
        {
          sv: ['articles.new.page_title', 'categories.flash.created', 'empty'],
          no: ['articles.new.page_title', 'categories.flash.created', 'empty', 'home.about']
        }
      }
      before { allow(I18n.backend).to receive(:translations).and_return(translations) }

      it 'should return a hash with keys with missing translations in each locale' do
        expect(keys.untranslated_keys).to eq expected
      end
    end

    describe 'missing_keys' do
      let(:file_path) { File.join(root_dir, 'config', 'locales', 'en.yml') }
      before do
        yaml = RailsI18nterface::Yamlfile.new(root_dir, :en)
        yaml.write({
          en: {
            home: {
              page_title: false,
              intro: {
                one: 'intro one',
                other: 'intro other'
              }
            }
          }
        })
        allow(keys).to receive(:files).and_return({
          :'home.page_title' => 'app/views/home/index.rhtml',
          :'home.intro' => 'app/views/home/index.rhtml',
          :'home.signup' => 'app/views/home/_signup.rhtml',
          :'about.index.page_title' => 'app/views/about/index.rhtml'          
        })
      end

      after(:each) do
        FileUtils.rm(file_path) if File.exists? file_path
      end

      it 'should return a hash with keys that are not in the locale file' do
        expect(keys.missing_keys.sort[0]).to eq "activerecord.attributes.article.active"
      end
    end


    describe 'translated_locales' do
      before do
        allow(I18n).to receive(:default_locale).and_return(:en)
        allow(I18n).to receive(:available_locales).and_return([:sv, :no, :en, :root])
      end

      it 'returns all avaiable except :root and the default' do
        expect(RailsI18nterface::Keys.translated_locales).to eq [:sv, :no]
      end
    end


  ##########################################################################
  #
  # Helper Methods
  #
  ##########################################################################

    def translations
      {
        en: {
          home: {
            about: 'This site is about making money'
          },
          articles: {
           new: {
             page_title: 'New Article'
            }
          },
          categories: {
            flash: {
             created: 'Category created'
            }
          },
          empty: nil
        },
        sv: {
          home: {
            about: false
          }
        }
      }
    end
  end

  def shallow_hash
    {
      'pressrelease.label.one' => 'Pressmeddelande',
      'pressrelease.label.other' => 'Pressmeddelanden',
      'article' => 'Artikel',
      'category' => ''
    }
  end

  def deep_hash
    {
      pressrelease: {
        label: {
          one: 'Pressmeddelande',
          other: 'Pressmeddelanden'
        }
      },
      article: 'Artikel',
      category: ''
    }
  end

end
