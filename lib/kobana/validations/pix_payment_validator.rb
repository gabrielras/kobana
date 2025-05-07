# frozen_string_literal: true

module Kobana
  module Validations
    class PixPaymentValidator
      ALLOWED_FIELDS  = %i[amount scheduled_to financial_account_uid qrcode identifier].freeze
      REQUIRED_FIELDS = %i[amount financial_account_uid qrcode].freeze

      def self.validate!(params)
        errors = {}

        validate_unexpected_fields(params, errors)
        validate_required_fields(params, errors)
        validate_optional_fields(params, errors)

        raise Kobana::ValidationError.new("Erro de validação no pagamento via QR Code", errors) if errors.any?

        true
      end

      def self.validate_unexpected_fields(params, errors)
        extra_keys = params.keys.map(&:to_sym) - ALLOWED_FIELDS
        extra_keys.each do |key|
          add_error(errors, key, "atributo não permitido")
        end
      end

      def self.validate_required_fields(params, errors)
        REQUIRED_FIELDS.each do |field|
          value = params[field]
          errors[field] = ["não pode ficar em branco"] if value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      def self.validate_optional_fields(params, errors)
        validate_amount(params[:amount], errors) if params[:amount]
        validate_scheduled_to(params[:scheduled_to], errors) if params.key?(:scheduled_to)
        validate_financial_account_uid(params[:financial_account_uid], errors) if params[:financial_account_uid]
        validate_qrcode(params[:qrcode], errors) if params[:qrcode]
        validate_identifier(params[:identifier], errors) if params.key?(:identifier)
      end

      def self.validate_amount(amount, errors)
        unless amount.is_a?(Numeric) || amount.to_s =~ /\A\d+(\.\d{1,2})?\z/
          add_error(errors, :amount, "deve ser um valor numérico válido")
        end

        add_error(errors, :amount, "deve ser maior que zero") if amount.to_f <= 0
      end

      def self.validate_scheduled_to(scheduled_to, errors)
        return if scheduled_to.nil?

        date = parse_date(scheduled_to)
        if date.nil?
          add_error(errors, :scheduled_to, "deve ser uma data válida no formato ISO8601")
        elsif date < DateTime.now
          add_error(errors, :scheduled_to, "deve ser uma data futura")
        end
      end

      def self.parse_date(value)
        value.is_a?(String) ? DateTime.parse(value) : value
      rescue ArgumentError
        nil
      end

      def self.validate_financial_account_uid(uid, errors)
        return if uid.to_s.match?(/\A[0-9a-fA-F-]{36}\z/)

        add_error(errors, :financial_account_uid, "deve ser um UUID válido")
      end

      def self.validate_qrcode(qrcode, errors)
        add_error(errors, :qrcode, "não pode ficar em branco") if qrcode.to_s.strip.empty?
      end

      def self.validate_identifier(identifier, errors)
        return if identifier.nil? || identifier.is_a?(String)

        add_error(errors, :identifier, "deve ser uma string ou nulo")
      end

      def self.add_error(errors, key, message)
        (errors[key] ||= []) << message
      end
    end
  end
end
