# encoding: utf-8

module RailsI18nterface
  module Sourcefiles
    module_function

    extend RailsI18nterface::Cache

    def load_files(root_dir)
      cachefile = File.join(root_dir, 'tmp', 'translation_strings')
      cache_load cachefile, root_dir do |options|
        RailsI18nterface::Sourcefiles.extract_files options
      end
    end

    def refresh(root_dir)
      cachefile = File.join(root_dir, 'tmp', 'translation_strings')
      FileUtils.rm cachefile if File.exists? cachefile
      load_files(root_dir)
    end

    def extract_files(root_dir)
      f = {}
      files_to_scan(root_dir).reduce(HashWithIndifferentAccess.new) do |files, file|
        f = files.merge! populate_keys(root_dir, file)
      end
      f.merge extract_activerecords(root_dir)
    end

    def populate_keys(root_dir, file)
      files = {}
      IO.read(file).scan(pattern2).each do |key, key2, count|
        key = key || key2
        path = relative_path(root_dir, file)
        if count
          keys = [key + '.zero', key + '.one', key + '.other']
        else
          keys = [key.to_s]
        end
        keys.map(&:to_sym).each do |k|
          files[k] ||= []
          files[k] << path unless files[k].include?(path)
        end
      end
      files
    end

    # old pattern for reference
    def pattern
      /\b
        (?:I18n\.t|I18n\.translate|t)
        (?:\s+|\():?(?:'|")
          (\.?[a-z0-9_\.]+)
        (?:'|")
        (?:\s*,\s*)?
        (count:|:count\s*=>)?
      /x
    end

    # also catch t(:symbol_keys)
    def pattern2
      /\b
        (?:I18n\.t|I18n\.translate|t)
        (?:\s+|\()(?:
          :?(?:'|")
            (\.?[a-z0-9_\.]+)
          (?:'|")
          |
          (?::)([a-z0-9_]+)
        )
        (?:\s*,\s*)?
        (count:|:count\s*=>)?
      /x
    end

    def relative_path(root_dir, file)
      Pathname.new(File.expand_path(file)).relative_path_from(Pathname.new(root_dir)).to_s
    end

    def files_to_scan(root_dir)
      Dir.glob(File.join(root_dir, '{app,config,lib}', '**', '*.{rb,erb,haml,slim,rhtml}')) +
        Dir.glob(File.join(root_dir, '{public,app/assets}', 'javascripts', '**', '*.{js,coffee}'))
    end

    def extract_activerecords(root_dir)
      files = {}
      schema = File.join(root_dir, 'db', 'schema.rb')
      if File.exists? schema
        regex = Regexp.new('\s*create_table\s"([^"]*)[^\n]*\n(.*?)\send\n', Regexp::MULTILINE)
        matchdata = regex.match(File.read(schema))
        while matchdata != nil
          model = matchdata[1].classify.underscore
          files["activerecord.models.#{model}"] = ['db/schema.rb']
          files.merge!(extract_attributes(model, matchdata[2]))
          matchdata = regex.match(matchdata.post_match)
        end
      end
      files
    end

    def extract_attributes(model, txt)
      files = {}
      regex = Regexp.new('\s*t\.[-_0-9a-z]*\s*"([^"]*?)"')
      matchdata = regex.match(txt)
      while !matchdata.nil?
        attribute = matchdata[1]
        files["activerecord.attributes.#{model}.#{attribute}"] = ['db/schema.rb']
        matchdata = regex.match(matchdata.post_match)
      end
      files
    end

  end
end
