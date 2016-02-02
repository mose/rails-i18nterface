# encoding: utf-8

require 'fileutils'

module RailsI18nterface
  class Yamlfile

    include Utils

    attr_reader :path

    def initialize(root_dir, locale)
      @root_dir = root_dir
      @locale = locale
      @file_path = File.join(@root_dir, 'config', 'locales', "#{locale}.yml")
    end

    def write(hash)
      write_raw(keys_to_yaml(hash))
    end

    def write_raw(yaml_string)
      FileUtils.mkdir_p File.dirname(@file_path)
      File.open(@file_path, 'w') do |file|
        file.puts yaml_string
      end
    end

    def read
      File.exists?(@file_path) ? YAML.load(IO.read(@file_path)) : {}
    end

    def write_to_file
      keys = { @locale => I18n.backend.send(:translations)[@locale] }
      write remove_blanks(keys)
    end

  end
end
