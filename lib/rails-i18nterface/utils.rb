module RailsI18nterface
  module Utils

    def remove_blanks hash
      hash.each { |k, v|
        if !v || v == ''
          hash.delete k
        end
        if v.is_a? Hash
          remove_blanks v
          if v == {}
            hash.delete k
          end
        end
      }
    end

    def set_nested(hash, key, value)
      if key.length == 1
        hash[key[0]] = value
      else
        k = key.shift
        set_nested(hash[k] ||= {}, key, value)
      end
    end

  end
end