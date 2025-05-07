# frozen_string_literal: true

module Kobana
  class RateLimitError < KobanaError
    attr_reader :limit, :remaining, :reset, :retry_after, :throttle_name, :response

    def initialize(response, message = "Limite de requisições excedido")
      super(message)
      @response = response
      headers = response.headers
      @limit         = headers["ratelimit-limit"]&.to_i
      @remaining     = headers["ratelimit-remaining"]&.to_i
      @reset         = headers["ratelimit-reset"]&.to_i
      @retry_after   = headers["retry-after"]&.to_i
      @throttle_name = headers["ratelimit-name"]
    end

    def reset_at
      Time.at(@reset) if @reset
    end
  end
end
