# encoding: utf-8

require 'spec_helper'

describe RailsI18nterface::TranslateController, :type => :controller do

  let(:root_dir) { File.expand_path(File.join('..', '..', '..', 'spec', 'internal'), __FILE__) }
  let(:yaml_trad) { File.join(root_dir, 'config', 'locales', 'en.yml') }

  before { @routes = RailsI18nterface::Engine.routes }
  after { FileUtils.rm yaml_trad if File.exists? yaml_trad }

  describe '.update' do
    let(:key_param) { {} }
    # hmm, this is called 7 times, I would like to know why
    # I18n.backend.should_receive(:store_translations)
    before { 
      session[:from_locale] = :sv
      session[:to_locale] = :en
      allow(RailsI18nterface::Yamlfile).to receive(:write_to_file)
    }
    it 'stores translations to I18n backend and then write them to a YAML file' do
      put :update, key: key_param
      expect(response).to be_redirect
    end
  end

  # TODO: improve this test
  it 'exports the yml file from current translations' do
    get :export, locale: 'en'
    expect(response.headers['Content-Disposition']).to eq "attachment; filename=en.yml"
  end

  # TODO: improve this test
  it 'reloads the string to translate from changed string in source code' do
    get :reload
    expect(response).to be_redirect
  end

  describe 'delete' do
    let(:file) { File.join(root_dir, 'app', 'views', 'categories', 'category.erb') }
    after { FileUtils.rm file if File.exists? file }
    it 'remove key on demand' do
      post :destroy, del: 'category_erb.key1'
      expect(response).to be_redirect
      get_page :index, per_page: 1, key_pattern: 'category_erb.key1', key_type: 'starts_with'
      expect(assigns :total_entries).to eq 0
      File.open(file,'w') do |f|
        f.write "<%= t(:'category_erb.key1') %>"
      end
      get :reload
    end
  end

  describe 'index' do

    include RailsI18nterface::Utils

    before do
      allow(I18n.backend).to receive(:translations).and_return(i18n_translations)
      I18n.backend.instance_eval { @initialized = true }
      allow(I18n).to receive(:valid_locales).and_return([:en, :sv])
      allow(I18n).to receive(:default_locale).and_return(:sv)
    end

    it 'can switch languages' do
      get_page :index, per_page: 1, from_locale: 'sv', to_locale: 'en'
      expect(assigns :from_locale).to be :sv
      expect(assigns :to_locale).to be :en
    end

    it 'shows sorted paginated keys from the translate from locale and extracted keys by default' do
      get_page :index, per_page: 1
      expect(assigns :from_locale).to be :sv
      expect(assigns :to_locale).to be :sv
      expect(assigns(:keys).all_keys.sort[0]).to eq 'activerecord.attributes.article.active'
      expect(assigns(:keys).translations.map(&:key)).to eq ['activerecord.attributes.article.active']
    end

    it 'can be paginated with the page param' do
      get_page :index, per_page: 1, :page => 2
      expect(assigns(:keys).translations.map(&:key)).to eq ['activerecord.attributes.article.body']
    end

    it 'has a default sort order by key' do
      get_page :index, per_page: 1
      expect(request.params[:sort_by]).to eq 'key'
    end

    it 'can sort by key' do
      get_page :index, per_page: 1, filter: 'translated', sort_by: 'key'
      expect(assigns(:keys).translations.map(&:key)).to eq ['articles.new.page_title']
    end

    it 'can sort by text' do
      get_page :index, per_page: 1, filter: 'translated', sort_by: 'text'
      expect(assigns(:keys).translations.map(&:key)).to eq ['vendor.foobar']
    end

    it 'can filter to see only the root items when using . as pattern' do
      get_page :index, per_page: 1, key_pattern: '.', key_type: 'starts_with'
      expect(assigns :total_entries).to be 1
      expect(assigns(:keys).translations.map(&:key)).to eq ['title']
    end

    it 'accepts a key_pattern param with key_type=starts_with' do
      get_page :index, per_page: 1, key_pattern: 'articles', key_type: 'starts_with'
      expect(assigns :total_entries).to be 1
      expect(assigns(:keys).translations.map(&:key)).to eq ['articles.new.page_title']
    end

    it 'accepts a key_pattern param with key_type=contains' do
      get_page :index, per_page: 1, key_pattern: 'page_', key_type: 'contains'
      expect(assigns :total_entries).to be 2
      expect(assigns(:keys).translations.map(&:key)).to eq ['articles.new.page_title']
    end

    it 'accepts a filter=untranslated param' do
      get_page :index, per_page: 1, filter: 'untranslated'
      expect(assigns(:keys).all_keys.sort[0]).to eq 'activerecord.attributes.article.active'
      expect(assigns(:keys).translations.map(&:key)).to eq ['activerecord.attributes.article.active']
    end

    it 'accepts a filter=translated param' do
      get_page :index, per_page: 1, filter: 'translated'
      expect(assigns :total_entries).to be 3
      expect(assigns(:keys).translations.map(&:key)).to eq ['articles.new.page_title']
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
    get(*args)
    expect(response).to be_success
  end

end
