# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::ApiError do
  let(:bad_request_response) do
    double("Faraday::Response", status: 400, body: { error: "Request failed" }.to_json)
  end

  let(:unauthorized_response) do
    double("Faraday::Response", status: 401, body: { error: "Unauthorized" }.to_json)
  end

  let(:custom_client_error_response) do
    double("Faraday::Response", status: 499, body: { error: "Request failed" }.to_json)
  end

  describe "#initialize" do
    context "quando a resposta tem status entre 400 e 499" do
      it "cria o erro corretamente para status 400" do
        error = described_class.new(bad_request_response)
        expect(error.status_code).to eq(400)
        expect(error.message).to match(/Erro na API \(status 400\)/)
      end

      it "cria o erro corretamente para status 401" do
        error = described_class.new(unauthorized_response)
        expect(error.status_code).to eq(401)
        expect(error.message).to match(/Erro na API \(status 401\)/)
      end

      it "cria o erro corretamente para status 499" do
        error = described_class.new(custom_client_error_response)
        expect(error.status_code).to eq(499)
        expect(error.message).to match(/Erro na API \(status 499\)/)
      end
    end
  end
end
