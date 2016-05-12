# encoding: utf-8

module RailsI18nterface
  class Keys

    include Utils

    attr_accessor :files, :keys, :namespaces
    attr_reader :yaml_keys, :all_keys, :translations

    def initialize(root_dir, from, to)
      @root_dir = root_dir
      @files = RailsI18nterface::Sourcefiles.load_files(root_dir)
      @yaml_keys = i18n_keys(I18n.default_locale)
      @from_locale = from
      @to_locale = to
      @all_keys = (@files.keys.map(&:to_s) + @yaml_keys).uniq
      @translations = []
      @namespaces = deep_sort(to_deep_hash(@all_keys))
    end

    def apply_filters(params)
      params[:filter] ||= 'all'
      remove_proc
      filter_by_translated(params[:filter]) if params[:filter] != 'all'
      filter_by_key_pattern(params[:key_type], params[:key_pattern]) unless params[:key_pattern].blank?
      filter_by_text_pattern(params[:text_type], params[:text_pattern]) unless params[:text_pattern].blank?
      sort_keys(params[:sort_by])
    end

    def remove_proc
      @all_keys.reject! do |key|
        lookup_key = lookup(@from_locale, key)
        lookup_key.is_a? Proc
      end
    end

    def filter_by_translated(filter)
      @all_keys.reject! do |key|
        if filter == 'untranslated'
          lookup(@to_locale, key).present?
        else # translated
          lookup(@to_locale, key).blank?
        end
      end
    end

    def filter_by_key_pattern(type, pattern)
      @all_keys.reject! do |key|
        if type == 'starts_with'
          if pattern == '.'
            key.match(/\./)
          else
            !key.starts_with?(pattern)
          end
        else # contains
          key.index(pattern).nil?
        end
      end
    end

    def filter_by_text_pattern(type, pattern)
      @all_keys.reject! do |key|
        lookup_key = lookup(@from_locale, key)
        if type == 'contains'
          !lookup_key.present? || !lookup_key.to_s.downcase.index(pattern.downcase)
        else # equals
          !lookup_key.present? || lookup_key.to_s.downcase != pattern.downcase
        end
      end
    end

    def sort_keys(order = 'key')
      if order == 'key'
        @all_keys.sort!
      else # text
        @all_keys.sort! do |key1, key2|
          if lookup(@from_locale, key1).present? && lookup(@from_locale, key2).present?
            lookup(@from_locale, key1).to_s.downcase <=> lookup(@from_locale, key2).to_s.downcase
          elsif lookup(@from_locale, key1).present?
            1
          else
            -1
          end
        end
      end
    end

    def reload(root_dir)
      @files = RailsI18nterface::Sourcefiles.refresh(root_dir)
      @yaml_keys = i18n_keys(I18n.default_locale)
      @all_keys = (@files.keys.map(&:to_s) + @yaml_keys).uniq
    end

    def i18n_keys(locale)
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
      to_shallow_hash(I18n.backend.send(:translations)[locale.to_sym]).keys.sort
    end

    def paginate(page, per_page)
      offset = (page - 1) * per_page
      @all_keys[offset, per_page].each do |key|
        translation = RailsI18nterface::Translation.new(key, @from_locale, @to_locale)
        translation.files = @files[key]
        translation.persisted = @yaml_keys.include? key
        @translations << translation
      end
    end

    def untranslated_keys
      self.class.translated_locales.reduce({}) do |a, e|
        a[e] = i18n_keys(I18n.default_locale).map do |key|
          I18n.backend.send(:lookup, e, key).nil? ? key : nil
        end.compact
        a
      end
    end

    def missing_keys
      locale = I18n.default_locale
      filepath = Dir.glob(File.join(@root_dir, 'config', 'locales', '**', "#{locale}.yml"))
      yaml_keys = {}
      yaml_keys = filepath.reduce({}) do |a, e|
        a = a.deep_merge(Yamlfile.new(@root_dir, locale).read[locale.to_s])
      end
      @files.keys.reject { |key, file| contains_key?(yaml_keys, key) }
    end

    def lookup(locale, key)
      I18n.backend.send(:lookup, locale, key)
    end

    def self.translated_locales
      I18n.available_locales.reject do |locale|
        [:root, I18n.default_locale.to_sym].include?(locale)
      end
    end

  end
end
