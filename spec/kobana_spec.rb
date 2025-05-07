# frozen_string_literal: true

# spec/lib/kobana_spec.rb

require "spec_helper"

RSpec.describe Kobana do
  before do
    Kobana.configuration = nil
  end

  describe ".configure" do
    it "configura a base_url corretamente" do
      Kobana.configure do |config|
        config.base_url = "https://api-sandbox.kobana.com.br"
      end

      expect(Kobana.configuration.base_url).to eq("https://api-sandbox.kobana.com.br")
    end

    it "configura o token corretamente" do
      Kobana.configure do |config|
        config.token = "test_token"
      end

      expect(Kobana.configuration.token).to eq("test_token")
    end

    it "configura o user_agent corretamente" do
      Kobana.configure do |config|
        config.user_agent = "TestAgent"
      end

      expect(Kobana.configuration.user_agent).to eq("TestAgent")
    end

    it "configura o uso do sandbox corretamente" do
      Kobana.configure do |config|
        config.use_sandbox = true
      end

      expect(Kobana.configuration.use_sandbox).to be(true)
      expect(Kobana.configuration.base_url).to eq(Kobana::SANDBOX_URL)
    end

    it "configura o número de tentativas de rede corretamente" do
      Kobana.configure do |config|
        config.max_network_retries = 5
      end

      expect(Kobana.configuration.max_network_retries).to eq(5)
    end

    it "configura o tempo de timeout corretamente" do
      Kobana.configure do |config|
        config.timeout = 120
      end

      expect(Kobana.configuration.timeout).to eq(120)
    end

    it "configura o tempo de open_timeout corretamente" do
      Kobana.configure do |config|
        config.open_timeout = 45
      end

      expect(Kobana.configuration.open_timeout).to eq(45)
    end

    it "configura o log_level corretamente" do
      Kobana.configure do |config|
        config.log_level = Kobana::LEVEL_DEBUG
      end

      expect(Kobana.configuration.log_level).to eq(Kobana::LEVEL_DEBUG)
    end

    it "configura o logger corretamente" do
      logger = double("Logger")
      Kobana.configure do |config|
        config.logger = logger
      end

      expect(Kobana.configuration.logger).to eq(logger)
    end
  end

  describe ".base_url=" do
    it "define corretamente o base_url para produção" do
      Kobana.base_url = "https://api-sandbox.kobana.com.br"
      expect(Kobana.configuration.base_url).to eq("https://api-sandbox.kobana.com.br")
    end
  end

  describe ".token=" do
    it "define corretamente o token" do
      Kobana.token = "new_token"
      expect(Kobana.configuration.token).to eq("new_token")
    end
  end

  describe ".user_agent=" do
    it "define corretamente o user_agent" do
      Kobana.user_agent = "CustomAgent"
      expect(Kobana.configuration.user_agent).to eq("CustomAgent")
    end
  end

  describe ".use_sandbox=" do
    it "altera para sandbox com a URL correta" do
      Kobana.use_sandbox = true
      expect(Kobana.configuration.use_sandbox).to be(true)
      expect(Kobana.configuration.base_url).to eq(Kobana::SANDBOX_URL)
    end

    it "altera para produção com a URL correta" do
      Kobana.use_sandbox = false
      expect(Kobana.configuration.use_sandbox).to be(false)
      expect(Kobana.configuration.base_url).to eq(Kobana::PRODUCTION_URL)
    end
  end

  describe ".max_network_retries=" do
    it "define corretamente o número máximo de tentativas de rede" do
      Kobana.max_network_retries = 3
      expect(Kobana.configuration.max_network_retries).to eq(3)
    end
  end

  describe ".timeout=" do
    it "define corretamente o tempo de timeout" do
      Kobana.timeout = 90
      expect(Kobana.configuration.timeout).to eq(90)
    end
  end

  describe ".open_timeout=" do
    it "define corretamente o tempo de open_timeout" do
      Kobana.open_timeout = 40
      expect(Kobana.configuration.open_timeout).to eq(40)
    end
  end

  describe ".log_level=" do
    it "define corretamente o nível de log" do
      Kobana.log_level = Kobana::LEVEL_WARN
      expect(Kobana.configuration.log_level).to eq(Kobana::LEVEL_WARN)
    end
  end

  describe ".logger=" do
    it "define corretamente o logger" do
      logger = double("Logger")
      Kobana.logger = logger
      expect(Kobana.configuration.logger).to eq(logger)
    end
  end
end
