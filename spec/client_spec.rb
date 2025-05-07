# frozen_string_literal: true

# spec/kobana/client_spec.rb

require "spec_helper"

RSpec.describe Kobana::Client do
  let(:config) do
    double(
      base_url: "https://sandbox.kobana.com.br/v1",
      token: "fake-token",
      user_agent: "Teste <teste@kobana.com.br>",
      timeout: 10,
      open_timeout: 5,
      max_network_retries: 0,
      validate!: true
    )
  end

  subject(:client) { described_class.new(config) }

  let(:success_response) do
    instance_double(Faraday::Response, status: 200, headers: {}, body: '{"ok":true}')
  end

  let(:error_response) do
    instance_double(Faraday::Response, status: 400, headers: {}, body: '{"error":"bad request"}')
  end

  describe "#request" do
    context "quando o método HTTP é válido" do
      it "retorna o corpo parseado quando a resposta for 200" do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(success_response)

        result = client.request(:get, "/teste", {})
        expect(result).to eq({ ok: true })
      end
    end

    context "quando o método HTTP é inválido" do
      it "lança uma exceção de método inválido" do
        expect do
          client.request(:invalid_method, "/teste")
        end.to raise_error(Kobana::KobanaError, /Método HTTP inválido/)
      end
    end

    context "quando a resposta não é um JSON válido" do
      it "lança uma exceção de parse" do
        invalid_body = instance_double(Faraday::Response, status: 200, headers: {}, body: "not_json")
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(invalid_body)

        expect do
          client.request(:get, "/teste")
        end.to raise_error(Kobana::KobanaError, /corpo não é um JSON válido/)
      end
    end

    context "quando ocorre um erro de timeout" do
      it "lança um erro de timeout customizado" do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)

        expect do
          client.request(:get, "/teste")
        end.to raise_error(Kobana::TimeoutError)
      end
    end

    context "quando ocorre falha de conexão" do
      it "lança um erro de conexão customizado" do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(
          Faraday::ConnectionFailed.new("Erro de rede")
        )

        expect do
          client.request(:get, "/teste")
        end.to raise_error(Kobana::ConnectionError)
      end
    end

    context "quando ocorre erro genérico" do
      it "lança um erro KobanaError genérico" do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise("Erro inesperado")

        expect do
          client.request(:get, "/teste")
        end.to raise_error(Kobana::KobanaError, /Erro inesperado/)
      end
    end
  end
end
