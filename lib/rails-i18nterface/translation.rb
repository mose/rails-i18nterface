# encoding: utf-8

module RailsI18nterface
  class Translation

    attr_accessor :files, :persisted
    attr_reader :key, :from_text, :to_text, :lines, :id

    def initialize(key, from, to)
      @key = key
      @from_text = lookup(from, key)
      @to_text = lookup(to, key)
      @lines = n_lines(@to_text)
      @id = key.gsub(/\./, '_')
      @files = []
      @persisted = true
    end

    def lookup(locale, key)
      I18n.backend.send(:lookup, locale, key)
    end

    def n_lines(text)
      n_lines = 1
      line_size = 100
      if text.present?
        n_lines = text.to_s.split("\n").size
        n_lines = text.to_s.length / line_size + 1 if n_lines == 1 && text.to_s.length > line_size
      end
      n_lines
    end

  end
end
