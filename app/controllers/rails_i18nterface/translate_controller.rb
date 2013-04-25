module RailsI18nterface
  class TranslateController < RailsI18nterface::ApplicationController

    include Utils

    before_filter :init_translations
    before_filter :set_locale

    def index
      @dbvalues = {}
      @keys = RailsI18nterface::Keys.new(Rails.root, @from_locale, @to_locale)
      @files = @keys.files
      @yaml_keys = @keys.yaml_keys
      @all_keys = @keys.all_keys
      @deep_keys = to_deep_hash(@all_keys)
      filter_by_key_pattern
      filter_by_text_pattern
      filter_by_translated_or_changed
      sort_keys
      paginate_keys
      @total_entries = @all_keys.size
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
      RailsI18nterface::Log.new(@from_locale, @to_locale, params[:key].keys).write_to_file
      force_init_translations # Force reload from YAML file
      flash[:notice] = "Translations stored"
      redirect_to root_path(params.slice(:filter, :sort_by, :key_type, :key_pattern, :text_type, :text_pattern))
    end

    def reload
      @keys.reload
      redirect_to root_path(params.slice(:filter, :sort_by, :key_type, :key_pattern, :text_type, :text_pattern))
    end

    private


    def lookup(locale, key)
      I18n.backend.send(:lookup, locale, key)
    end
    helper_method :lookup

    def filter_by_translated_or_changed
      params[:filter] ||= 'all'
      return if params[:filter] == 'all'
      @all_keys.reject! do |key|
        case params[:filter]
        when 'untranslated'
          lookup(@to_locale, key).present?
        when 'translated'
          lookup(@to_locale, key).blank?
        when 'changed'
          old_from_text(key).blank? || lookup(@from_locale, key) == old_from_text(key)
        else
          raise "Unknown filter '#{params[:filter]}'"
        end
      end
    end

    def filter_by_key_pattern
      return if params[:key_pattern].blank?
      @all_keys.reject! do |key|
        case params[:key_type]
        when "starts_with"
          if params[:key_pattern] == '.'
            key.match(/\./)
          else
            !key.starts_with?(params[:key_pattern])
          end
        when "contains"
          key.index(params[:key_pattern]).nil?
        else
          raise "Unknown key_type '#{params[:key_type]}'"
        end
      end
    end

    def filter_by_text_pattern
      return if params[:text_pattern].blank?
      @all_keys.reject! do |key|
        lookup_key = lookup(@from_locale, key)
        case params[:text_type]
        when 'contains'
          !lookup_key.present? || !lookup_key.to_s.downcase.index(params[:text_pattern].downcase)
        when 'equals'
          !lookup_key.present? || lookup_key.to_s.downcase != params[:text_pattern].downcase
        else
          raise "Unknown text_type '#{params[:text_type]}'"
        end
      end
    end

    def sort_keys
      params[:sort_by] ||= "key"
      case params[:sort_by]
      when "key"
        @all_keys.sort!
      when "text"
        @all_keys.sort! do |key1, key2|
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
      @paginated_keys = @all_keys[offset, per_page]
    end

    def offset
      (params[:page].to_i - 1) * per_page
    end

    def per_page
      params[:per_page] ? params[:per_page].to_i : 50
    end
    helper_method :per_page

    def init_translations
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    end

    def force_init_translations
      I18n.backend.send(:init_translations) rescue false
    end

    def default_locale
      I18n.default_locale
    end

    def set_locale
      session[:from_locale] ||= default_locale
      session[:to_locale] ||= :en
      session[:from_locale] = params[:from_locale] if params[:from_locale].present?
      session[:to_locale] = params[:to_locale] if params[:to_locale].present?
      @from_locale = session[:from_locale].to_sym
      @to_locale = session[:to_locale].to_sym
    end

    def old_from_text(key)
      return @old_from_text[key] if @old_from_text && @old_from_text[key]
      @old_from_text = {}
      text = key.split(".").reduce(log_hash) do |hash, k|
        hash ? hash[k] : nil
      end
      @old_from_text[key] = text
    end
    helper_method :old_from_text

    def log_hash
      @log_hash ||= RailsI18nterface::Log.new(@from_locale, @to_locale, {}).read
    end
  end
end
