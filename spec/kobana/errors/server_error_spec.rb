# frozen_string_literal: true

# spec/lib/kobana/server_error_spec.rb

require "spec_helper"

RSpec.describe Kobana::ServerError do
  let(:response) { double("Faraday::Response", status: 500) }

  subject(:error) { described_class.new(response) }

  describe "#initialize" do
    it "armazena o response" do
      expect(error.response).to eq(response)
    end

    it "extrai o status_code corretamente" do
      expect(error.status_code).to eq(500)
    end

    it "define a mensagem de erro corretamente" do
      expect(error.message).to eq("Erro interno do servidor: 500")
    end
  end
end
