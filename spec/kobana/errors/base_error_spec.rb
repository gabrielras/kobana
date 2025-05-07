# frozen_string_literal: true

# spec/lib/kobana/kobana_error_spec.rb

require "spec_helper"

RSpec.describe Kobana do
  describe Kobana::KobanaError do
    it "é uma subclasse de StandardError" do
      expect(Kobana::KobanaError).to be < StandardError
    end
  end

  describe Kobana::ConfigurationError do
    it "é uma subclasse de KobanaError" do
      expect(Kobana::ConfigurationError).to be < Kobana::KobanaError
    end
  end

  describe Kobana::ConnectionError do
    it "é uma subclasse de KobanaError" do
      expect(Kobana::ConnectionError).to be < Kobana::KobanaError
    end
  end

  describe Kobana::TimeoutError do
    it "é uma subclasse de KobanaError" do
      expect(Kobana::TimeoutError).to be < Kobana::KobanaError
    end
  end

  describe Kobana::ValidationError do
    let(:errors_hash) { { campo: "não pode ficar em branco" } }

    it "é uma subclasse de KobanaError" do
      expect(Kobana::ValidationError).to be < Kobana::KobanaError
    end

    it "define uma mensagem padrão" do
      error = described_class.new
      expect(error.message).to eq("Erro de validação")
    end

    it "permite definir uma mensagem customizada" do
      error = described_class.new("Dados inválidos")
      expect(error.message).to eq("Dados inválidos")
    end

    it "armazena os erros recebidos" do
      error = described_class.new("Erro", errors_hash)
      expect(error.errors).to eq(errors_hash)
    end
  end
end
