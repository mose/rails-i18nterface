# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::TranslateController do
  describe 'index' do

    include RailsI18nterface::Utils

    before(:each) do
      controller.stub!(:per_page).and_return(1)
      I18n.backend.stub!(:translations).and_return(i18n_translations)
      I18n.backend.instance_eval { @initialized = true }
      I18n.stub!(:valid_locales).and_return([:en, :sv])
      I18n.stub!(:default_locale).and_return(:sv)
    end

    it 'shows sorted paginated keys from the translate from locale and extracted keys by default' do
      get_page :index, use_route: 'rails-i18nterface'
      assigns(:from_locale).should == :sv
      assigns(:to_locale).should == :en
      assigns(:all_keys).size.should == 22
      assigns(:paginated_keys).should == ['activerecord.attributes.article.active']
    end

    it 'can be paginated with the page param' do
      get_page :index, :page => 2, use_route: 'rails-i18nterface'
      assigns(:paginated_keys).should == ['activerecord.attributes.article.body']
    end

    it 'accepts a key_pattern param with key_type=starts_with' do
      get_page :index, :key_pattern => 'articles', :key_type => 'starts_with', use_route: 'rails-i18nterface'
      assigns(:paginated_keys).should == ['articles.new.page_title']
      assigns(:total_entries).should == 1
    end

    it 'accepts a key_pattern param with key_type=contains' do
      get_page :index, :key_pattern => 'page_', :key_type => 'contains', use_route: 'rails-i18nterface'
      assigns(:total_entries).should == 2
      assigns(:paginated_keys).should == ['articles.new.page_title']
    end

    it 'accepts a filter=untranslated param' do
      get_page :index, :filter => 'untranslated', use_route: 'rails-i18nterface'
      assigns(:total_entries).should == 21
      assigns(:paginated_keys).should == ['activerecord.attributes.article.active']
    end

    it 'accepts a filter=translated param' do
      get_page :index, :filter => 'translated', use_route: 'rails-i18nterface'
      assigns(:total_entries).should == 1
      assigns(:paginated_keys).should == ['vendor.foobar']
    end

    # it 'accepts a filter=changed param' do
    #   log = mock(:log)
    #   old_translations = {:home => {:page_title => 'Skapar ny artikel'}}
    #   log.should_receive(:read).and_return(deep_stringify_keys(old_translations))
    #   get_page :index, :filter => 'changed', use_route: 'rails-i18nterface'
    #   assigns(:total_entries).should == 1
    #   assigns(:keys).should == ['home.page_title']
    # end

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
      # translations = {
      #   :articles => {
      #     :new => {
      #       :title => 'New Article'
      #     }
      #   },
      #   :category => 'Category'
      # }
      key_param = {'articles.new.title' => 'New Article', 'category' => 'Category'}
      #I18n.backend.should_receive(:store_translations).with(:en, translations)
      put :update, key: key_param, version: 1, use_route: 'rails-i18nterface'
      response.should be_redirect
    end
  end

  def get_page(*args)
    get(*args, use_route: 'rails-i18nterface')
    response.should be_success
  end

end
