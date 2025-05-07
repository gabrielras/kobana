# frozen_string_literal: true

require "spec_helper"

RSpec.describe Kobana::Validations::PixPaymentValidator do
  describe ".validate!" do
    let(:valid_params) do
      {
        amount: "100",
        financial_account_uid: "123e4567-e89b-12d3-a456-426614174000",
        qrcode: "6052022"
      }
    end

    context "com parâmetros válidos" do
      it "retorna true" do
        expect(described_class.validate!(valid_params)).to eq(true)
      end
    end

    context "sem o campo amount" do
      it "lança um erro de validação" do
        params = valid_params.except(:amount)

        begin
          described_class.validate!(params)
          raise "Esperava erro de validação, mas nenhum foi lançado"
        rescue Kobana::ValidationError => e
          expect(e.errors).to include(:amount)
        end
      end
    end

    context "sem o campo financial_account_uid" do
      it "lança um erro de validação" do
        params = valid_params.except(:financial_account_uid)

        begin
          described_class.validate!(params)
          raise "Esperava erro de validação, mas nenhum foi lançado"
        rescue Kobana::ValidationError => e
          expect(e.errors).to include(:financial_account_uid)
        end
      end
    end

    context "sem o campo qrcode" do
      it "lança um erro de validação" do
        params = valid_params.except(:qrcode)

        begin
          described_class.validate!(params)
          raise "Esperava erro de validação, mas nenhum foi lançado"
        rescue Kobana::ValidationError => e
          expect(e.errors).to include(:qrcode)
        end
      end
    end

    context "com campo extra não permitido" do
      it "lança um erro de validação" do
        params = valid_params.merge(foo: "bar")

        begin
          described_class.validate!(params)
          raise "Esperava erro de validação, mas nenhum foi lançado"
        rescue Kobana::ValidationError => e
          expect(e.errors).to include(:foo)
        end
      end
    end

    context "com amount inválido" do
      it "lança erro se amount for negativo" do
        params = valid_params.merge(amount: "-50")

        begin
          described_class.validate!(params)
          raise "Esperava erro de validação, mas nenhum foi lançado"
        rescue Kobana::ValidationError => e
          expect(e.errors[:amount]).to include("deve ser maior que zero")
        end
      end

      it "lança erro se amount for string não numérica" do
        params = valid_params.merge(amount: "abc")

        begin
          described_class.validate!(params)
          raise "Esperava erro de validação, mas nenhum foi lançado"
        rescue Kobana::ValidationError => e
          expect(e.errors[:amount]).to include("deve ser um valor numérico válido")
        end
      end
    end
  end
end
