# frozen_string_literal: true

require "logger"

module Kobana
  class Configuration
    attr_accessor :base_url, :token, :user_agent, :max_network_retries,
                  :timeout, :open_timeout, :logger, :log_level, :use_sandbox

    def use_sandbox=(value)
      @use_sandbox = value
      @base_url = value ? Kobana::SANDBOX_URL : Kobana::PRODUCTION_URL
    end

    def initialize
      self.use_sandbox = false
      @base_url = Kobana::PRODUCTION_URL
      @token = nil
      @user_agent = nil
      @max_network_retries = 0
      @timeout = 60
      @open_timeout = 30
      @log_level = :info
      @logger = Logger.new($stdout)
      @logger.level = Logger::INFO
    end

    def log_level=(level)
      @log_level = level

      @logger.level = case level
                      when :debug then Logger::DEBUG
                      when :info then Logger::INFO
                      when :warn then Logger::WARN
                      when :error then Logger::ERROR
                      else Logger::INFO
                      end
    end

    def validate!
      raise Kobana::ConfigurationError, "Token da API não configurado" if @token.nil? || @token.empty?
    end
  end
end
