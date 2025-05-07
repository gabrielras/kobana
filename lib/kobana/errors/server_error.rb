# frozen_string_literal: true

module Kobana
  class ServerError < KobanaError
    attr_reader :response, :status_code

    def initialize(response)
      @response = response
      @status_code = response.status
      super("Erro interno do servidor: #{response.status}")
    end
  end
end
