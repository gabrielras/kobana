# frozen_string_literal: true

# spec/lib/kobana/utils/log_spec.rb

require "spec_helper"

RSpec.describe Kobana::Utils::Log do
  let(:logger) { double("Logger") }

  before do
    allow(Kobana.configuration).to receive(:logger).and_return(logger)
  end

  describe ".log" do
    it "não faz nada se o logger não estiver configurado" do
      allow(Kobana.configuration).to receive(:logger).and_return(nil)

      expect(logger).not_to receive(:send)
      described_class.log(:debug, "Test message")
    end

    it "não faz nada se o nível de log for inferior ao nível de log configurado" do
      allow(Kobana.configuration).to receive(:log_level).and_return(:info)

      expect(logger).not_to receive(:send)
      described_class.log(:debug, "Test message")
    end

    it "loga a mensagem quando o nível de log é igual ou superior ao configurado" do
      allow(Kobana.configuration).to receive(:log_level).and_return(:debug)

      expect(logger).to receive(:debug).with("Test message")
      described_class.log(:debug, "Test message")
    end
  end

  describe ".log_level_value" do
    it "retorna o valor correto para cada nível de log" do
      expect(described_class.log_level_value(:debug)).to eq(0)
      expect(described_class.log_level_value(:info)).to eq(1)
      expect(described_class.log_level_value(:warn)).to eq(2)
      expect(described_class.log_level_value(:error)).to eq(3)
      expect(described_class.log_level_value(:unknown)).to eq(4)
    end
  end
end
