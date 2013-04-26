# encoding: utf-8

module RailsI18nterface
  module Cache

    def cache_save(obj, uri)
      FileUtils.rm uri if File.exists? uri
      File.open(uri, 'wb') do |f|
        Marshal.dump(obj, f)
      end
      obj
    end

    def cache_load(uri, options={}, &process)
      if File.file? uri
        load uri
      elsif block_given?
        cache_save(yield(options), uri)
      else
        nil
      end
    end

    private

    def load(uri)
      File.open(uri) do |f|
        Marshal.load f
      end
    end


  end
end