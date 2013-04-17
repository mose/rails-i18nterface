require 'fileutils'

module RailsI18nterface
  class Yamlfile
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def write(hash)
      FileUtils.mkdir_p File.dirname(@path)
      File.open(@path, "w") do |file|
        file.puts keys_to_yaml(hash)
      end
    end

    def read
      File.exists?(path) ? YAML::load(IO.read(@path)) : {}
    end

    # Stringifying keys for prettier YAML
    def deep_stringify_keys(hash)
      hash.inject({}) { |result, (key, value)|
        value = deep_stringify_keys(value) if value.is_a? Hash
        result[(key.to_s rescue key) || key] = value
        result
      }
    end

    def keys_to_yaml(hash)
      # Using ya2yaml, if available, for UTF8 support
      keys = deep_stringify_keys(hash)
      keys.respond_to?(:ya2yaml) ? keys.ya2yaml(:escape_as_utf8 => true) : keys.to_yaml
    end
  end
end
