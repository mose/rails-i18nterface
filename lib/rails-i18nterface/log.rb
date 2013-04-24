module RailsI18nterface
  class Log

    include Utils

    attr_accessor :from_locale, :to_locale, :keys

    def initialize(from_locale, to_locale, keys)
      self.from_locale = from_locale
      self.to_locale = to_locale
      self.keys = keys.reject { |k, v| v == '' }
    end

    def write_to_file
      current_texts = File.exists?(file_path) ? file.read : {}
      current_texts.merge!(from_texts)
      file.write(remove_blanks(current_texts))
    end

    def read
      file.read
    end

    private
    def file
      @file ||= Yamlfile.new(file_path)
    end

    def from_texts
      file.deep_stringify_keys(to_deep_hash(keys.reduce({ }) do |hash, key|
        hash[key] = I18n.backend.send(:lookup, from_locale, key)
        hash
      end))
    end

    def file_path
      File.join(Rails.root, 'config', 'locales', 'log', "from_#{from_locale}_to_#{to_locale}.yml")
    end
  end
end