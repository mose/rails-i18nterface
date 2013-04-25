# encoding: utf-8

module RailsI18nterface
  module Cache

    def cache_save(obj, uri, options={})
      FileUtils.rm uri if File.exists? uri
      File.open(uri, 'wb') do |f|
        Marshal.dump(obj, f)
      end
    end

    def cache_load(uri, file, &process)
      mtime = File.mtime(file)
      if cached?(uri) && uptodate?(uri, file)
        File.open(uri) do |f|
          Marshal.load f
        end
      else
        if block_given?
          obj = yield
          cache_save(obj, uri)
          File.utime(mtime, mtime, uri)
          obj
        else
          nil
        end
      end
    end

    def cached?(uri)
      File.file? uri
    end

    def uptodate?(uri, file)
      File.mtime(uri) == File.mtime(file)
    end

  end
end