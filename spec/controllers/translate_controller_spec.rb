# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::TranslateController do
  describe 'index' do

    include RailsI18nterface::Utils

    before(:each) do
      I18n.backend.stub!(:translations).and_return(i18n_translations)
      I18n.backend.instance_eval { @initialized = true }
      I18n.stub!(:valid_locales).and_return([:en, :sv])
      I18n.stub!(:default_locale).and_return(:sv)
    end

    it 'shows sorted paginated keys from the translate from locale and extracted keys by default' do
      get_page :index, per_page: 1, use_route: 'rails-i18nterface'
      assigns(:from_locale).should == :sv
      assigns(:to_locale).should == :sv
      assigns(:keys).all_keys.size.should == 22
      assigns(:paginated_keys).should == ['activerecord.attributes.article.active']
    end

    it 'can be paginated with the page param' do
      get_page :index, per_page: 1, :page => 2, use_route: 'rails-i18nterface'
      assigns(:paginated_keys).should == ['activerecord.attributes.article.body']
    end

    it 'can sort by key' do
      get_page :index, per_page: 1, filter: 'translated', sort_by: 'key', use_route: 'rails-i18nterface'
      assigns(:paginated_keys).should == ['articles.new.page_title']
    end

    it 'can sort by text' do
      get_page :index, per_page: 1, filter: 'translated', sort_by: 'text', use_route: 'rails-i18nterface'
      assigns(:paginated_keys).should == ['vendor.foobar']
    end

    it 'accepts a key_pattern param with key_type=starts_with' do
      get_page :index, per_page: 1, key_pattern: 'articles', key_type: 'starts_with', use_route: 'rails-i18nterface'
      assigns(:paginated_keys).should == ['articles.new.page_title']
      assigns(:keys).all_keys.size.should == 1
    end

    it 'accepts a key_pattern param with key_type=contains' do
      get_page :index, per_page: 1, key_pattern: 'page_', key_type: 'contains', use_route: 'rails-i18nterface'
      assigns(:keys).all_keys.size.should == 2
      assigns(:paginated_keys).should == ['articles.new.page_title']
    end

    it 'accepts a filter=untranslated param' do
      get_page :index, per_page: 1, filter: 'untranslated', use_route: 'rails-i18nterface'
      assigns(:keys).all_keys.size.should == 19
      assigns(:paginated_keys).should == ['activerecord.attributes.article.active']
    end

    it 'accepts a filter=translated param' do
      get_page :index, per_page: 1, filter: 'translated', use_route: 'rails-i18nterface'
      assigns(:keys).all_keys.size.should == 3
      assigns(:paginated_keys).should == ['articles.new.page_title']
    end

    def i18n_translations
      HashWithIndifferentAccess.new({
        :en => {
          :vendor => {
            :foobar => 'Foo Baar'
          }
        },
        :sv => {
          :articles => {
            :new => {
              :page_title => 'Skapa ny artikel'
            }
          },
          :home => {
            :page_title => 'Valkommen till I18n'
          },
          :vendor => {
            :foobar => 'Fobar'
          }
        }
      })
    end

    def files
      HashWithIndifferentAccess.new({
        :'home.page_title' => ['app/views/home/index.rhtml'],
        :'general.back' => ['app/views/articles/new.rhtml', 'app/views/categories/new.rhtml'],
        :'articles.new.page_title' => ['app/views/articles/new.rhtml']
      })
    end
  end

  describe 'translate' do

    it 'should store translations to I18n backend and then write them to a YAML file' do
      session[:from_locale] = :sv
      session[:to_locale] = :en
      key_param = {}
      # hmm, this is called 7 times, I would like to know why
      # I18n.backend.should_receive(:store_translations)
      RailsI18nterface::Yamlfile.stub!(:write_to_file)
      put :update, key: key_param, use_route: 'rails-i18nterface'
      response.should be_redirect

    end
  end

  def get_page(*args)
    get(*args, use_route: 'rails-i18nterface')
    response.should be_success
  end

end
