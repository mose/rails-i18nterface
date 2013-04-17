module RailsI18nterface
  class Sourcefiles

    def self.extract_files
      self.files_to_scan.inject(HashWithIndifferentAccess.new) do |files, file|
        begin #hack to avoid UTF-8 error
          IO.read(file).scan(self.i18n_lookup_pattern).flatten.map(&:to_sym).each do |key|
            path = Pathname.new(File.expand_path(file)).relative_path_from(Pathname.new(Rails.root)).to_s
            files[key] ||= []
            files[key] << path if !files[key].include?(path)
          end
        rescue Exception => e
          puts e.inspect
          puts e.backtrace
        end
        files
      end
    end

    def self.i18n_lookup_pattern
      /\b(?:I18n\.t|I18n\.translate|t)(?:\s|\():?(?:'|")(\.?[a-z0-9_\.]+)(?:'|")/
    end

    def self.files_to_scan
      Dir.glob(File.join(Storage.root_dir, "{app,config,lib}", "**","*.{rb,erb,haml,slim,rhtml}")) +
        Dir.glob(File.join(Storage.root_dir, "{public,app/assets}", "javascripts", "**","*.{js,coffee}"))
    end

  end
end