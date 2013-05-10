# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::TranslateController do

  after :each do
    root_dir = File.expand_path(File.join('..', '..', '..', 'spec', 'internal'), __FILE__)
    yaml_trad = File.join(root_dir, 'config', 'locales', 'en.yml')
    FileUtils.rm yaml_trad if File.exists? yaml_trad
  end

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

  # TODO: improve this test
  it 'exports the yml file from current translations' do
    get :export, locale: 'en', use_route: 'rails-i18nterface'
    response.headers['Content-Disposition'].should == "attachment; filename=en.yml"
  end

  # TODO: improve this test
  it 'reloads the string to translate from changed string in source code' do
    get :reload, use_route: 'rails-i18nterface'
    response.should be_redirect
  end

  describe 'index' do

    include RailsI18nterface::Utils

    before(:each) do
      I18n.backend.stub!(:translations).and_return(i18n_translations)
      I18n.backend.instance_eval { @initialized = true }
      I18n.stub!(:valid_locales).and_return([:en, :sv])
      I18n.stub!(:default_locale).and_return(:sv)
    end

    it 'can switch languages' do
      get_page :index, per_page: 1, from_locale: 'sv', to_locale: 'en', use_route: 'rails-i18nterface'
      expect(assigns :from_locale).to be :sv
      expect(assigns :to_locale).to be :en
    end

    it 'shows sorted paginated keys from the translate from locale and extracted keys by default' do
      get_page :index, per_page: 1, use_route: 'rails-i18nterface'
      expect(assigns :from_locale).to be :sv
      expect(assigns :to_locale).to be :sv
      expect(assigns(:keys).all_keys.sort[0]).to eq 'activerecord.attributes.article.active'
      expect(assigns :paginated_keys).to eq ['activerecord.attributes.article.active']
    end

    it 'can be paginated with the page param' do
      get_page :index, per_page: 1, :page => 2, use_route: 'rails-i18nterface'
      expect(assigns :paginated_keys).to eq ['activerecord.attributes.article.body']
    end

    it 'has a default sort order by key' do
      get_page :index, per_page: 1, use_route: 'rails-i18nterface'
      expect(request.params[:sort_by]).to eq 'key'
    end

    it 'can sort by key' do
      get_page :index, per_page: 1, filter: 'translated', sort_by: 'key', use_route: 'rails-i18nterface'
      expect(assigns :paginated_keys).to eq ['articles.new.page_title']
    end

    it 'can sort by text' do
      get_page :index, per_page: 1, filter: 'translated', sort_by: 'text', use_route: 'rails-i18nterface'
      expect(assigns(:paginated_keys)).to eq ['vendor.foobar']
    end

    it 'can filter to see only the root items when using . as pattern' do
      get_page :index, per_page: 1, key_pattern: '.', key_type: 'starts_with', use_route: 'rails-i18nterface'
      expect(assigns :paginated_keys).to eq ['title']
      expect(assigns(:keys).all_keys.size).to be 1
    end

    it 'accepts a key_pattern param with key_type=starts_with' do
      get_page :index, per_page: 1, key_pattern: 'articles', key_type: 'starts_with', use_route: 'rails-i18nterface'
      expect(assigns :paginated_keys).to eq ['articles.new.page_title']
      expect(assigns(:keys).all_keys.size).to be 1
    end

    it 'accepts a key_pattern param with key_type=contains' do
      get_page :index, per_page: 1, key_pattern: 'page_', key_type: 'contains', use_route: 'rails-i18nterface'
      expect(assigns(:keys).all_keys.size).to be 2
      expect(assigns :paginated_keys).to eq ['articles.new.page_title']
    end

    it 'accepts a filter=untranslated param' do
      get_page :index, per_page: 1, filter: 'untranslated', use_route: 'rails-i18nterface'
      expect(assigns(:keys).all_keys.sort[0]).to eq 'activerecord.attributes.article.active'
      expect(assigns :paginated_keys).to eq ['activerecord.attributes.article.active']
    end

    it 'accepts a filter=translated param' do
      get_page :index, per_page: 1, filter: 'translated', use_route: 'rails-i18nterface'
      expect(assigns(:keys).all_keys.size).to be 3
      expect(assigns :paginated_keys).to eq ['articles.new.page_title']
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

  def get_page(*args)
    get(*args, use_route: 'rails-i18nterface')
    expect(response).to be_success
  end

end
