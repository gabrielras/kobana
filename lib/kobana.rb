# frozen_string_literal: true

require "kobana/version"
require "kobana/configuration"
require "kobana/client"
require "kobana/errors"
require "kobana/utils"
require "kobana/resources/pix_payment"
require "kobana/validations/pix_payment_validator"

module Kobana
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
      configuration
    end

    def base_url=(url)
      configure do |config|
        config.base_url = url
      end
    end

    def token=(token)
      configure do |config|
        config.token = token
      end
    end

    def user_agent=(user_agent)
      configure do |config|
        config.user_agent = user_agent
      end
    end

    def use_sandbox=(use_sandbox)
      configure do |config|
        config.use_sandbox = use_sandbox
      end
    end

    def max_network_retries=(retries)
      configure do |config|
        config.max_network_retries = retries
      end
    end

    def timeout=(timeout)
      configure do |config|
        config.timeout = timeout
      end
    end

    def open_timeout=(timeout)
      configure do |config|
        config.open_timeout = timeout
      end
    end

    def log_level=(level)
      configure do |config|
        config.log_level = level
      end
    end

    def logger=(logger)
      configure do |config|
        config.logger = logger
      end
    end
  end

  PRODUCTION_URL = "https://api.kobana.com.br/v2"
  SANDBOX_URL = "https://api-sandbox.kobana.com.br/v2"

  LEVEL_DEBUG = :debug
  LEVEL_INFO = :info
  LEVEL_WARN = :warn
  LEVEL_ERROR = :error

  configure do |config|
    config.base_url = PRODUCTION_URL
    config.use_sandbox = false
    config.token = nil
    config.user_agent = nil
    config.max_network_retries = 0
    config.timeout = 60
    config.open_timeout = 30
    config.log_level = LEVEL_INFO
  end
end
