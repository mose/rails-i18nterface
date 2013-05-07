# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::Keys do

  include RailsI18nterface::Utils

  before(:each) do
    @root_dir = File.expand_path(File.join('..', '..', '..', 'spec', 'internal'), __FILE__)
    @keys = RailsI18nterface::Keys.new(@root_dir, :sv, :no)
  end

  it 'extracts keys from I18n lookups in .rb, .html.erb, and .rhtml files' do
    @keys.files.keys.map(&:to_s).sort.should == [
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
      'category_erb.key1',
      'category_html_erb.key1',
      'category_rhtml.key1',
      'js.alert'
    ]
  end

  it 'return a hash with I18n keys and file lists' do
    @keys.files[:'article.key3'].should == ['app/models/article.rb']
  end

  it 'reloads the translatable strings' do
    size = @keys.all_keys.size
    @keys.reload(@root_dir).size.should == size
  end

  describe 'i18n_keys' do
    before(:each) do
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    end

    it 'should return all keys in the I18n backend translations hash' do
      I18n.backend.should_receive(:translations).and_return(translations)
      @keys.i18n_keys(:en).should == ['articles.new.page_title', 'categories.flash.created', 'empty', 'home.about']
    end

    describe 'untranslated_keys' do
      before(:each) do
        I18n.backend.stub!(:translations).and_return(translations)
      end

      it 'should return a hash with keys with missing translations in each locale' do
        @keys.untranslated_keys.should == {
          :sv => ['articles.new.page_title', 'categories.flash.created', 'empty'],
          :no => ['articles.new.page_title', 'categories.flash.created', 'empty', 'home.about']
        }
      end
    end

    describe 'missing_keys' do
      before(:each) do
        @file_path = File.join(@root_dir, 'config', 'locales', 'en.yml')
        yaml = RailsI18nterface::Yamlfile.new(@root_dir, :en)
        yaml.write({
          :en => {
            :home => {
              :page_title => false,
              :intro => {
                :one => 'intro one',
                :other => 'intro other'
              }
            }
          }
        })
      end

      after(:each) do
        FileUtils.rm(@file_path) if File.exists? @file_path
      end

      it 'should return a hash with keys that are not in the locale file' do
        @keys.stub!(:files).and_return({
          :'home.page_title' => 'app/views/home/index.rhtml',
          :'home.intro' => 'app/views/home/index.rhtml',
          :'home.signup' => 'app/views/home/_signup.rhtml',
          :'about.index.page_title' => 'app/views/about/index.rhtml'
        })
        @keys.missing_keys.size.should == 24
      end
    end


    describe 'translated_locales' do
      before(:each) do
        I18n.stub!(:default_locale).and_return(:en)
        I18n.stub!(:available_locales).and_return([:sv, :no, :en, :root])
      end

      it 'returns all avaiable except :root and the default' do
        RailsI18nterface::Keys.translated_locales.should == [:sv, :no]
      end
    end


  ##########################################################################
  #
  # Helper Methods
  #
  ##########################################################################

    def translations
      {
        :en => {
          :home => {
            :about => 'This site is about making money'
          },
          :articles => {
           :new => {
             :page_title => 'New Article'
            }
          },
          :categories => {
            :flash => {
             :created => 'Category created'
            }
          },
          :empty => nil
        },
        :sv => {
          :home => {
            :about => false
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
      :pressrelease => {
        :label => {
          :one => 'Pressmeddelande',
          :other => 'Pressmeddelanden'
        }
      },
      :article => 'Artikel',
      :category => ''
    }
  end

end
