module RailsI18nterface
  module Utils

    def remove_blanks(hash)
      hash.each do |k, v|
        hash.delete k if !v || v == ''
        if v.is_a? Hash
          remove_blanks v
          hash.delete k if v == {}
        end
      end
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