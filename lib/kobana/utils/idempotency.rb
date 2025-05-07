# frozen_string_literal: true

require "securerandom"

module Kobana
  module Utils
    module Idempotency
      module_function

      def generate_idempotency_key
        SecureRandom.uuid
      end
    end
  end
end
