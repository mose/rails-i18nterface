if ENV['sauce']

  module Job
    module_function

    def id
      @__jobid || 'undefined'
    end

    def id=(j)
      @__jobid ||= j
    end

    def failed?
      !!@__failed
    end

    def fails
      @__failed = true
    end

    def build
      Time.now.to_i.to_s
    end
    
  end

  require 'sauce/capybara'
  require 'rest_client'

  Capybara.javascript_driver = :sauce
  Sauce.config do |c|
    c[:browsers] = [
      ["Windows 7", "iehta", "9"]
    ]
  end

  RSpec.configure do |config|
    config.after :each do
      Job.id = page.driver.browser.send(:bridge).session_id
      Job.fails unless example.exception.nil?
    end

    config.after :suite do
      http = "https://saucelabs.com/rest/v1/#{ENV["SAUCE_USERNAME"]}/jobs/#{Job.id}"
      body = {
        name: "RailsI18nterface",
        passed: !Job.failed?,
        public: 'public',
        tags: ['rails-i18nterface'],
        build: Job.build,
        "custom-data" => { version: RailsI18nterface::VERSION }
        }.to_json
      # puts 'http: ' + http
      # puts 'body: ' + body
      RestClient::Request.execute(
        :method => :put,
        :url => http,
        :user => ENV["SAUCE_USERNAME"],
        :password => ENV["SAUCE_ACCESS_KEY"],
        :headers => {:content_type => "application/json"},
        :payload => body
      )
    end
  end

end

