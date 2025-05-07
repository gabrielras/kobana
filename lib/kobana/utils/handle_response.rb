# frozen_string_literal: true

module Kobana
  module Utils
    module HandleResponse
      module_function

      def handle_api_error(response)
        case response.status
        when 429
          raise Kobana::RateLimitError, response
        when 400..499
          raise Kobana::ApiError, response
        when 500..599
          raise Kobana::ServerError, response
        else
          raise Kobana::KobanaError, "Erro inesperado (status #{response.status})"
        end
      end
    end
  end
end
