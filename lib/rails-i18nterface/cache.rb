module RailsI18nterface
  module Cache

    def save_store(obj,uri,options={})
      File.open(uri,'wb') do |f|
        Marshal.dump(obj,f)
      end
    end

    def load_store(uri, &process)
      if stored? uri
        File.open(uri) do |f|
          Marshal.load f
        end
      else
        if block_given?
          obj = yield
          save_store(obj, uri)
          obj
        else
          nil
        end
      end
    end

    def stored?(uri)
      File.file? uri
    end

  end
end