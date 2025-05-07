# frozen_string_literal: true

# spec/kobana/configuration_spec.rb
require "spec_helper"

RSpec.describe Kobana::Configuration do
  subject(:config) { described_class.new }

  # Testa os valores padrão da configuração
  describe "valores padrão" do
    it "usa a URL de produção como padrão" do
      expect(config.base_url).to eq(Kobana::PRODUCTION_URL)
    end

    it "inicia com token nulo" do
      expect(config.token).to be_nil
    end

    it "inicia com user_agent nulo" do
      expect(config.user_agent).to be_nil
    end

    it "inicia com 0 tentativas de nova conexão" do
      expect(config.max_network_retries).to eq(0)
    end

    it "inicia com timeout de 60 segundos" do
      expect(config.timeout).to eq(60)
    end

    it "inicia com open_timeout de 30 segundos" do
      expect(config.open_timeout).to eq(30)
    end

    it "inicia com nível de log :info" do
      expect(config.log_level).to eq(:info)
      expect(config.logger.level).to eq(Logger::INFO)
    end

    it "inicia com uso de sandbox desabilitado" do
      expect(config.use_sandbox).to be false
    end
  end

  describe "#validate!" do
    context "quando o token é nulo" do
      it "lança um erro de configuração" do
        config.token = nil
        expect { config.validate! }.to raise_error(Kobana::ConfigurationError)
      end
    end

    context "quando o token é uma string vazia" do
      it "lança um erro de configuração" do
        config.token = ""
        expect { config.validate! }.to raise_error(Kobana::ConfigurationError)
      end
    end

    context "quando o token está presente" do
      it "não lança erro" do
        config.token = "abc123"
        expect { config.validate! }.not_to raise_error
      end
    end
  end

  describe "#log_level=" do
    it "define o nível do logger como DEBUG" do
      config.log_level = :debug
      expect(config.logger.level).to eq(Logger::DEBUG)
    end

    it "define o nível do logger como WARN" do
      config.log_level = :warn
      expect(config.logger.level).to eq(Logger::WARN)
    end

    it "define o nível do logger como ERROR" do
      config.log_level = :error
      expect(config.logger.level).to eq(Logger::ERROR)
    end

    it "define o nível do logger como INFO para níveis desconhecidos" do
      config.log_level = :invalid
      expect(config.logger.level).to eq(Logger::INFO)
    end
  end
end
