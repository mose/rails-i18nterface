module RailsI18nterface
  module S3
    class Manager
      include RailsI18nterface::Utils

      def export_locale(locale)
        return false if RailsI18nterface.aws_secret_access_key.nil? || RailsI18nterface.aws_access_key_id.nil?

        bucket = get_bucket(RailsI18nterface.aws_bucket_name, s3_client)
        write_file_to_bucket(bucket, locale)

        true
      end

      def export_all
        I18n.available_locales.each do |e|
          export_locale(e)
        end
      end

      def load_all_locales
        I18n.available_locales.each do |e|
          load_locale(e)
        end
      end

      def load_locale(locale)
        return false if RailsI18nterface.aws_secret_access_key.nil? || RailsI18nterface.aws_access_key_id.nil?

        bucket = get_bucket(RailsI18nterface.aws_bucket_name, s3_client)
        file = get_s3_object(bucket, translation_file_path(locale))

        return unless file.exists?
        yaml_content = file.get.body.read

        inject_keys_to_i18n(yaml_content)

        RailsI18nterface::Yamlfile.new(Rails.root, locale).write_raw(yaml_content)
        force_init_translations

        true
      end

      def s3_client
        Aws::S3::Resource.new(region: RailsI18nterface.aws_region)
      end

      def inject_keys_to_i18n(yaml_content)
        return unless I18n.backend.respond_to? :store_translations
        keys = YAML.parse(yaml_content)
        I18n.backend.store_translations(@to_locale, to_deep_hash(keys))
      end

      private

      def get_bucket(name, s3)
        s3.buckets.select { |e| e.name == name }.first
      end

      def write_file_to_bucket(bucket, locale)
        yaml = load_locale_yml(locale)
        get_s3_object(bucket, translation_file_path(locale)).put(body: yaml, acl: 'public-read')
      end

      def load_locale_yml(locale)
        keys = {locale => I18n.backend.send(:translations)[locale] || {}}
        remove_blanks(keys)
        keys_to_yaml(keys)
      end

      def get_s3_object(bucket, key)
        bucket.object(key)
      end

      def translation_file_path(locale)
        "translations/#{locale}.yml"
      end

      def force_init_translations
        I18n.backend.send(:init_translations) rescue false
      end
    end
  end
end