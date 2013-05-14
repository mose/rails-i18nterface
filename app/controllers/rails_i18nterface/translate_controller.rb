# encoding: utf-8

module RailsI18nterface
  class TranslateController < RailsI18nterface::ApplicationController

    include Utils

    before_filter :init

    def index
      @keys = RailsI18nterface::Keys.new(Rails.root, @from_locale, @to_locale)
      @keys.apply_filters(params)
      @keys.paginate(@page, @per_page)
      @total_entries = @keys.all_keys.size
      @page_title = 'Translate'
      @show_filters = ['all', 'untranslated', 'translated']
    end

    def destroy
      params[:key] = { params[:del] => '' }
      update
    end

    def export
      locale = params[:locale].to_sym
      keys = {locale => I18n.backend.send(:translations)[locale] || {}}
      remove_blanks keys
      yaml = keys_to_yaml(keys)
      response.headers['Content-Disposition'] = "attachment; filename=#{locale}.yml"
      render :text => yaml
    end

    def update
      if I18n.backend.respond_to? :store_translations
        I18n.backend.store_translations(@to_locale, to_deep_hash(params[:key]))
      end
      yaml = RailsI18nterface::Yamlfile.new(Rails.root, @to_locale)
      yaml.write_to_file
      force_init_translations
      flash[:notice] = 'Translations stored'
      redirect_to root_path(params.slice(:filter, :sort_by, :key_type, :key_pattern, :text_type, :text_pattern))
    end

    def reload
      @keys = RailsI18nterface::Keys.new(Rails.root, @from_locale, @to_locale)
      @keys.reload(Rails.root)
      redirect_to root_path(params.slice(:filter, :sort_by, :key_type, :key_pattern, :text_type, :text_pattern))
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
      @page = (params[:page] || 1).to_i
    end

    def init_session
      session[:from_locale] ||= I18n.default_locale
      session[:to_locale] ||= I18n.default_locale
      session[:per_page] ||= 50
      session[:from_locale] = params[:from_locale] if params[:from_locale].present?
      session[:to_locale] = params[:to_locale] if params[:to_locale].present?
      session[:per_page] = params[:per_page].to_i if params[:per_page].present?
    end

    def init_translations
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    end

    def force_init_translations
      I18n.backend.send(:init_translations) rescue false
    end

  end
end
