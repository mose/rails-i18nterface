# encoding: utf-8

module RailsI18nterface
  module Sourcefiles

    extend RailsI18nterface::Cache

    def self.load_files(root_dir)
      cachefile = File.join(root_dir, 'tmp', 'translation_strings')
      cache_load cachefile, root_dir do |options|
        RailsI18nterface::Sourcefiles.extract_files options
      end
    end

    def self.refresh(root_dir)
      cachefile = File.join(root_dir, 'tmp', 'translation_strings')
      FileUtils.rm cachefile if File.exists? cachefile
      self.load_files(root_dir)
    end

    def self.extract_files(root_dir)
      i18n_lookup_pattern = /\b
        (?:I18n\.t|I18n\.translate|t)
        (?:\s|\():?(?:'|")
          (\.?[a-z0-9_\.]+)
        (?:'|")
        /x
      f = {}
      self.files_to_scan(root_dir).reduce(HashWithIndifferentAccess.new) do |files, file|
        f = files.merge! self.populate_keys(root_dir, file, i18n_lookup_pattern)
      end
      f.merge self.extract_activerecords(root_dir)
    end

    def self.populate_keys(root_dir, file, pattern)
      files = {}
      IO.read(file).scan(pattern).flatten.map(&:to_sym).each do |key|
        path = self.relative_path(file)
        files[key] ||= []
        files[key] << path unless files[key].include?(path)
      end
      files
    end

    def self.relative_path(file)
      Pathname.new(File.expand_path(file)).relative_path_from(Pathname.new(Rails.root)).to_s
    end

    def self.files_to_scan(root_dir)
      Dir.glob(File.join(root_dir, '{app,config,lib}', '**', '*.{rb,erb,haml,slim,rhtml}')) +
        Dir.glob(File.join(root_dir, '{public,app/assets}', 'javascripts', '**', '*.{js,coffee}'))
    end

    def self.extract_activerecords(root_dir)
      files = {}
      schema = File.join(root_dir, 'db', 'schema.rb')
      if File.exists? schema
        regex = Regexp.new('\s*create_table\s"([^"]*)[^\n]*\n(.*?)\send\n', Regexp::MULTILINE)
        matchdata = regex.match(File.read(schema))
        while matchdata != nil
          model = matchdata[1].classify.underscore
          files["activerecord.models.#{model}"] = ['db/schema.rb']
          files.merge!(self.extract_attributes(model, matchdata[2]))
          matchdata = regex.match(matchdata.post_match)
        end
      end
      files
    end

    def self.extract_attributes(model, txt)
      files = {}
      regex = Regexp.new('\s*t\.[-_0-9a-z]*\s*"([^"]*?)"')
      matchdata = regex.match(txt)
      while matchdata != nil
        attribute = matchdata[1]
        files["activerecord.attributes.#{model}.#{attribute}"] = ['db/schema.rb']
        matchdata = regex.match(matchdata.post_match)
      end
      files
    end

  end
end