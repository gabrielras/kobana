# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Resources::PixPayment do
  describe ".create" do
    let(:params) do
      {
        amount: "100",
        financial_account_uid: "1234abcd-5678-efgh-ijkl-9876mnopqrst",
        qrcode: "6052022"
      }
    end

    let(:idempotency_key) { "unique-idempotency-key" }
    let(:client) { instance_double(Kobana::Client) }
    let(:response) { instance_double("Faraday::Response", status: 200, body: { success: true }.to_json) }

    before do
      allow(Kobana::Client).to receive(:new).and_return(client)
      allow(client).to receive(:request).and_return(response)
    end

    context "quando os parâmetros são válidos" do
      it "valida os parâmetros com o PixPaymentValidator" do
        expect(Kobana::Validations::PixPaymentValidator).to receive(:validate!).with(params)

        described_class.create(params, idempotency_key)
      end
    end

    context "quando a validação falha" do
      it "lança um erro de validação" do
        invalid_params = { amount: nil, financial_account_uid: nil, qrcode: nil }

        expect do
          described_class.create(invalid_params, idempotency_key)
        end.to raise_error(Kobana::ValidationError)
      end
    end
  end
end
