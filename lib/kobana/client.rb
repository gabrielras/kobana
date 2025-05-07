# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "json"

module Kobana
  class Client
    attr_reader :config

    def initialize(config = Kobana.configuration)
      @config = config
      @config.validate!
    end

    def request(method, path, params = {}, idempotency_key = nil)
      validate_http_method!(method)
      idempotency_key ||= generate_idempotency_key_if_needed(method)

      headers = build_headers(idempotency_key)

      response = perform_request(method, path, headers, params)
      handle_response(response)
    rescue Faraday::TimeoutError => e
      handle_timeout_error(e)
    rescue Faraday::ConnectionFailed => e
      handle_connection_error(e)
    rescue Kobana::KobanaError, Kobana::RateLimitError, Kobana::ApiError, Kobana::ServerError => e
      raise e
    rescue StandardError => e
      handle_generic_error(e)
    end

    private

    def perform_request(method, path, headers, params)
      connection.send(method) do |req|
        configure_request(req, method, path, headers, params)
      end
    end

    def configure_request(req, method, path, headers, params)
      req.url path
      req.headers = headers

      if %i[post put patch].include?(method) && params
        req.body = JSON.generate(params)
      elsif params
        req.params = params
      end

      Kobana::Utils::Log.log_request(method, "#{config.base_url}#{path}", headers, req.body)
    end

    def generate_idempotency_key_if_needed(method)
      %i[post put patch].include?(method.to_sym) ? Kobana::Utils::Idempotency.generate_idempotency_key : nil
    end

    def handle_timeout_error(timeout_error)
      Kobana::Utils::Log.log_error(timeout_error)
      raise Kobana::TimeoutError, "A requisição excedeu o tempo limite: #{timeout_error.message}"
    end

    def handle_connection_error(connection_error)
      Kobana::Utils::Log.log_error(connection_error)
      raise Kobana::ConnectionError, "Falha na conexão com a API Kobana: #{connection_error.message}"
    end

    def handle_generic_error(generic_error)
      Kobana::Utils::Log.log_error(generic_error)
      raise Kobana::KobanaError, "Erro inesperado durante a requisição: #{generic_error.message}"
    end

    def connection
      @connection ||= build_connection
    end

    def build_connection
      Faraday.new(url: config.base_url) do |faraday|
        configure_timeouts(faraday)
        configure_retries(faraday) if config.max_network_retries.positive?
        faraday.adapter Faraday.default_adapter
      end
    end

    def configure_timeouts(faraday)
      faraday.options.timeout = config.timeout
      faraday.options.open_timeout = config.open_timeout
    end

    def configure_retries(faraday)
      faraday.request :retry, {
        max: config.max_network_retries,
        interval: 0.5,
        interval_randomness: 0.5,
        backoff_factor: 2,
        retry_statuses: [429, 500, 502, 503, 504],
        methods: %i[get post put delete head patch],
        retry_block: lambda { |_env, _options, retries, exc|
          Kobana::Utils::Log.log(:warn, "Retry #{retries}/#{config.max_network_retries}: #{exc&.message}")
        }
      }
    end

    def build_headers(idempotency_key = nil)
      headers = {
        "Authorization" => "Bearer #{config.token}",
        "User-Agent" => config.user_agent,
        "Content-Type" => "application/json",
        "Accept" => "application/json"
      }
      headers["X-Idempotency-Key"] = idempotency_key if idempotency_key
      headers
    end

    def handle_response(response)
      Kobana::Utils::Log.log_response(response.status, response.headers, response.body)
      case response.status
      when 200, 201
        parse_response_body(response.body)
      else
        Kobana::Utils::HandleResponse.handle_api_error(response)
      end
    end

    def parse_response_body(body)
      return {} if body.nil? || body.empty?

      JSON.parse(body, symbolize_names: true)
    rescue JSON::ParserError
      raise Kobana::KobanaError, "Falha ao processar resposta da API: corpo não é um JSON válido"
    end

    def validate_http_method!(method)
      allowed_methods = %i[get post put delete head patch]
      return if allowed_methods.include?(method)

      error_message = "Método HTTP inválido: #{method}. Permitidos: #{allowed_methods.join(", ")}"
      Kobana::Utils::Log.log_error(error_message)
      raise Kobana::KobanaError, error_message
    end
  end
end
