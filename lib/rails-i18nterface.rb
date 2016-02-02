# encoding: utf-8

require 'rails-i18nterface/engine'
require 'rails-i18nterface/utils'
require 'rails-i18nterface/s3/manager'
require 'rails-i18nterface/cache'
require 'rails-i18nterface/yamlfile'
require 'rails-i18nterface/sourcefiles'
require 'rails-i18nterface/keys'
require 'rails-i18nterface/translation'

module RailsI18nterface
  mattr_accessor :aws_access_key_id
  mattr_accessor :aws_secret_access_key
  mattr_accessor :aws_region
  mattr_accessor :aws_bucket_name

  def self.setup
    yield self
  end

  def self.setup_aws(api_id, api_secret, s3_region, s3_bucket_name)
    Aws.config.update(
        {
            region: s3_region,
            credentials: Aws::Credentials.new(api_id, api_secret)
        }
    )

    self.aws_access_key_id = api_id
    self.aws_secret_access_key = api_secret
    self.aws_region = s3_region
    self.aws_bucket_name = s3_bucket_name
  end
end
