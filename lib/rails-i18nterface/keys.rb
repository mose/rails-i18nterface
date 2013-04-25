#require 'pathname'

module RailsI18nterface
  class Keys

    include Utils

    attr_accessor :files, :keys
    attr_reader :yaml_keys, :all_keys

    def initialize(root_dir, from, to)
      @root_dir = root_dir
      @files = RailsI18nterface::Sourcefiles.extract_files(root_dir)
      @yaml_keys = i18n_keys(I18n.default_locale)
      @from_locale = from
      @to_locale = to
      @all_keys = (@files.keys.map(&:to_s) + @yaml_keys).uniq
    end

    def reload
      @files = RailsI18nterface::Sourcefiles.extract_files(root_dir)
      @yaml_keys = i18n_keys(I18n.default_locale)
      @all_keys = (@files.keys.map(&:to_s) + @yaml_keys).uniq
    end

    def i18n_keys(locale)
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
      to_shallow_hash(I18n.backend.send(:translations)[locale.to_sym]).keys.sort
    end

    def untranslated_keys
      self.class.translated_locales.reduce({}) do |missing, locale|
        missing[locale] = i18n_keys(I18n.default_locale).map do |key|
          I18n.backend.send(:lookup, locale, key).nil? ? key : nil
        end.compact
        missing
      end
    end

    def missing_keys
      locale = I18n.default_locale
      filepath = Dir.glob(File.join(Rails.root, 'config', 'locales', '**', "#{locale}.yml"))
      yaml_keys = {}
      yaml_keys = filepath.reduce({}) do |keys, path|
        keys = keys.deep_merge(Yamlfile.new(path).read[locale.to_s])
      end
      files.reject { |key, file| contains_key?(yaml_keys, key) }
    end

    def self.translated_locales
      I18n.available_locales.reject do |locale|
        [:root, I18n.default_locale.to_sym].include?(locale)
      end
    end

  end
end