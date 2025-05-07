# frozen_string_literal: true

module Kobana
  module Resources
    class PixPayment
      PATH = "/v2/payment/pix"

      def self.create(params, idempotency_key = nil)
        Kobana::Validations::PixPaymentValidator.validate!(params)
        payload = params

        client = Kobana::Client.new
        client.request(:post, PATH, payload, idempotency_key)
      end
    end
  end
end
