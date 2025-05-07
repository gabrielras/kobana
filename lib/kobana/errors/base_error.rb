# frozen_string_literal: true

module Kobana
  class KobanaError < StandardError; end
  class ConfigurationError < KobanaError; end
  class ConnectionError < KobanaError; end
  class TimeoutError < KobanaError; end

  class ValidationError < KobanaError
    attr_reader :errors

    def initialize(message = "Erro de validação", errors = {})
      @errors = errors
      super(message)
    end
  end
end
