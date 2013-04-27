# encoding: utf-8

module RailsI18nterface
  class TranslateController < RailsI18nterface::ApplicationController

    include Utils

    before_filter :init_translations
    before_filter :set_locale

    def index
      @dbvalues = {}
      @keys = RailsI18nterface::Keys.new(Rails.root, @from_locale, @to_locale)
      @keys.apply_filters(params)
      paginate_keys
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
      @keys.reload
      redirect_to root_path(params.slice(:filter, :sort_by, :key_type, :key_pattern, :text_type, :text_pattern))
    end

    private

    def filter_by_translated_or_changed
      params[:filter] ||= 'all'
      return if params[:filter] == 'all'
      @keys.all_keys.reject! do |key|
        if params[:filter] == 'untranslated'
          lookup(@to_locale, key).present?
        else #translated
          lookup(@to_locale, key).blank?
        end
      end
    end

    def filter_by_key_pattern
      return if params[:key_pattern].blank?
      @keys.all_keys.reject! do |key|
        if params[:key_type] == 'starts_with'
          if params[:key_pattern] == '.'
            key.match(/\./)
          else
            !key.starts_with?(params[:key_pattern])
          end
        else #contains
          key.index(params[:key_pattern]).nil?
        end
      end
    end

    def filter_by_text_pattern
      return if params[:text_pattern].blank?
      @keys.all_keys.reject! do |key|
        lookup_key = lookup(@from_locale, key)
        if params[:text_type] == 'contains'
          !lookup_key.present? || !lookup_key.to_s.downcase.index(params[:text_pattern].downcase)
        else #equals
          !lookup_key.present? || lookup_key.to_s.downcase != params[:text_pattern].downcase
        end
      end
    end

    def sort_keys
      params[:sort_by] ||= 'key'
      case params[:sort_by]
      when 'key'
        @keys.all_keys.sort!
      when 'text'
        @keys.all_keys.sort! do |key1, key2|
          if lookup(@from_locale, key1).present? && lookup(@from_locale, key2).present?
            lookup(@from_locale, key1).to_s.downcase <=> lookup(@from_locale, key2).to_s.downcase
          elsif lookup(@from_locale, key1).present?
            -1
          else
            1
          end
        end
      else
        raise "Unknown sort_by '#{params[:sort_by]}'"
      end
    end

    def paginate_keys
      params[:page] ||= 1
      @paginated_keys = @keys.all_keys[offset, @per_page]
    end

    def offset
      (params[:page].to_i - 1) * @per_page
    end

    def init_translations
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    end

    def force_init_translations
      I18n.backend.send(:init_translations) rescue false
    end

    def set_locale
      session[:from_locale] ||= I18n.default_locale
      session[:to_locale] ||= I18n.default_locale
      session[:per_page] ||= 50
      session[:from_locale] = params[:from_locale] if params[:from_locale].present?
      session[:to_locale] = params[:to_locale] if params[:tolocale].present?
      session[:per_page] = params[:per_page].to_i if params[:per_page].present?
      @from_locale = session[:from_locale].to_sym
      @to_locale = session[:to_locale].to_sym
      @per_page = session[:per_page]
    end

  end
end
