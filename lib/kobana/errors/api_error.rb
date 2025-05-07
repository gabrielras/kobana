# frozen_string_literal: true

module Kobana
  class ApiError < KobanaError
    attr_reader :response, :status_code

    def initialize(response)
      @status_code = response.status
      @response = parse_response_body(response.body)
      super("Erro na API (status #{@status_code})")
    end

    private

    def parse_response_body(body)
      return {} if body.nil? || body.empty?

      JSON.parse(body, symbolize_names: true)
    rescue JSON::ParserError
      raise Kobana::KobanaError, "Falha ao processar resposta da API: corpo não é um JSON válido"
    end
  end
end
