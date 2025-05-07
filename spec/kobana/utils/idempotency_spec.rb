# frozen_string_literal: true

# spec/lib/kobana/utils/idempotency_spec.rb

require "spec_helper"

RSpec.describe Kobana::Utils::Idempotency do
  describe ".generate_idempotency_key" do
    it "gera chaves diferentes a cada chamada" do
      key1 = described_class.generate_idempotency_key
      key2 = described_class.generate_idempotency_key

      expect(key1).not_to eq(key2)
    end
  end
end
