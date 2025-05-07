# frozen_string_literal: true

# spec/lib/kobana/utils/handle_response_spec.rb

require "spec_helper"

RSpec.describe Kobana::Utils::HandleResponse do
  describe ".handle_api_error" do
    let(:headers) { { "Content-Type" => "application/json" } }
    let(:body) { '{"error":"mensagem de erro"}' }

    let(:response) do
      double(
        "Faraday::Response",
        status: status_code,
        headers: headers,
        body: body
      )
    end

    context "quando o status da resposta é 429 (RateLimitError)" do
      let(:status_code) { 429 }

      it "levanta um Kobana::RateLimitError" do
        expect { described_class.handle_api_error(response) }
          .to raise_error(Kobana::RateLimitError)
      end
    end

    context "quando o status da resposta está entre 400 e 499 (ApiError)" do
      let(:status_code) { 400 }

      it "levanta um Kobana::ApiError" do
        expect { described_class.handle_api_error(response) }
          .to raise_error(Kobana::ApiError)
      end
    end

    context "quando o status da resposta está entre 500 e 599 (ServerError)" do
      let(:status_code) { 500 }

      it "levanta um Kobana::ServerError" do
        expect { described_class.handle_api_error(response) }
          .to raise_error(Kobana::ServerError)
      end
    end

    context "quando o status da resposta não é um erro esperado" do
      let(:status_code) { 200 }

      it "levanta um Kobana::KobanaError" do
        expect { described_class.handle_api_error(response) }
          .to raise_error(Kobana::KobanaError, /Erro inesperado/)
      end
    end
  end
end
