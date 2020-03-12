# encoding: utf-8

module RailsI18nterface
  class TranslateController < RailsI18nterface::ApplicationController
    include Utils

    before_action :init

    def index
      @keys = RailsI18nterface::Keys.new(Rails.root, @from_locale, @to_locale)
      @keys.apply_filters(params)
      @keys.paginate(@page, @per_page)
      @total_entries = @keys.all_keys.size
      @page_title = 'Translate'
      @show_filters = %w(all untranslated translated)
    end

    def destroy
      params[:key] = { params[:del] => '' }
      update
    end

    def export
      locale = page_params.fetch(:locale).to_sym
      keys = { locale => I18n.backend.send(:translations)[locale] || {} }
      remove_blanks keys
      yaml = keys_to_yaml(keys)
      response.headers['Content-Disposition'] = "attachment; filename=#{locale}.yml"
      render plain: yaml
    end

    def update
      if I18n.backend.respond_to? :store_translations
        I18n.backend.store_translations(@to_locale, to_deep_hash(update_params.to_h))
      end
      yaml = RailsI18nterface::Yamlfile.new(Rails.root, @to_locale)
      yaml.write_to_file
      force_init_translations
      flash[:notice] = 'Translations stored'
      reload
    end

    def reload
      @keys = RailsI18nterface::Keys.new(Rails.root, @from_locale, @to_locale)
      @keys.reload(Rails.root)
      redirect_to root_path(filter_params) and return
    end

    protected

    def init
      init_session
      init_assigns
      init_translations
      init_sort
    end

    def init_sort
      params[:sort_by] ||= 'key'
    end

    def init_assigns
      @from_locale = session[:from_locale].to_sym
      @to_locale = session[:to_locale].to_sym
      @per_page = session[:per_page]
      @page = if page_params.has_key?(:page)
        @page = page_params.fetch(:page).to_i
      else
        @page = 1
      end
    end

    def init_session
      session[:from_locale] ||= I18n.default_locale
      session[:to_locale] ||= I18n.default_locale
      session[:per_page] ||= 50
      session[:from_locale] = page_params.fetch(:from_locale) if page_params.has_key?(:from_locale)
      session[:to_locale] = page_params.fetch(:to_locale) if page_params.has_key?(:to_locale)
      session[:per_page] = page_params.fetch(:per_page).to_i if page_params.has_key?(:per_page)
    end

    def init_translations
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    end

    def force_init_translations
      I18n.backend.send(:init_translations) rescue false
    end

    def filter_params
      params.permit(:filter, :sort_by, :key_type, :key_pattern, :text_type, :text_pattern)
    end
    private


    def update_params
      params.permit(:key)
    end

    def page_params
      params.permit(:page, :from_locale, :to_locale, :per_page, :locale)
    end

  end
end
