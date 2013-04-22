module RailsI18nterface
  module Sourcefiles

    def self.extract_files
      i18n_lookup_pattern = /\b
        (?:I18n\.t|I18n\.translate|t)
        (?:\s|\():?(?:'|")
          (\.?[a-z0-9_\.]+)
        (?:'|")
        /x
      f = {}
      self.files_to_scan.reduce(HashWithIndifferentAccess.new) do |files, file|
        f = files.merge! self.populate_keys(file, i18n_lookup_pattern)
      end
      f.merge self.extract_activerecords
    end

    def self.populate_keys(file, pattern)
      files = self.extract_activerecords
      begin #hack to avoid UTF-8 error
        IO.read(file).scan(pattern).flatten.map(&:to_sym).each do |key|
          path = self.relative_path(file)
          files[key] ||= []
          files[key] << path unless files[key].include?(path)
        end
      rescue Exception => e
        puts e.inspect
        puts e.backtrace
      end
      files
    end

    def self.relative_path(file)
      Pathname.new(File.expand_path(file)).relative_path_from(Pathname.new(Rails.root)).to_s
    end

    def self.files_to_scan
      Dir.glob(File.join(Storage.root_dir, '{app,config,lib}', '**', '*.{rb,erb,haml,slim,rhtml}')) +
        Dir.glob(File.join(Storage.root_dir, '{public,app/assets}', 'javascripts', '**', '*.{js,coffee}'))
    end

    def self.extract_activerecords
      files = {}
      schema = File.join(Storage.root_dir, 'db', 'schema.rb')
      if File.exists? schema
        regex = Regexp.new('\s*create_table\s"([^"]*)[^\n]*\n(.*?)\send\n', Regexp::MULTILINE)
        matchdata = regex.match(File.read(schema))
        while matchdata != nil
          model = matchdata[1]
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