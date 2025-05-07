# frozen_string_literal: true

# spec/lib/kobana/rate_limit_error_spec.rb

require "spec_helper"

RSpec.describe Kobana::RateLimitError do
  let(:response) do
    double("Faraday::Response", headers: {
             "ratelimit-limit" => "100",
             "ratelimit-remaining" => "0",
             "ratelimit-reset" => "1627904400",
             "retry-after" => "60",
             "ratelimit-name" => "example-throttle"
           })
  end

  subject(:error) { described_class.new(response) }

  describe "#initialize" do
    it "armazena o response" do
      expect(error.response).to eq(response)
    end

    it "extrai corretamente o limit" do
      expect(error.limit).to eq(100)
    end

    it "extrai corretamente o remaining" do
      expect(error.remaining).to eq(0)
    end

    it "extrai corretamente o reset" do
      expect(error.reset).to eq(1_627_904_400)
    end

    it "extrai corretamente o retry_after" do
      expect(error.retry_after).to eq(60)
    end

    it "extrai corretamente o throttle_name" do
      expect(error.throttle_name).to eq("example-throttle")
    end
  end

  describe "#reset_at" do
    it "converte o reset para o horário correto" do
      expect(error.reset_at).to eq(Time.at(1_627_904_400))
    end

    it "retorna nil quando o reset não é fornecido" do
      empty_response = double("Faraday::Response", headers: {})
      empty_error = described_class.new(empty_response)
      expect(empty_error.reset_at).to be_nil
    end
  end
end
