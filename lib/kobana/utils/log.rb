# frozen_string_literal: true

module Kobana
  module Utils
    module Log
      module_function

      def log(level, message)
        return unless Kobana.configuration.logger
        return if log_level_value(level) < log_level_value(Kobana.configuration.log_level)

        Kobana.configuration.logger.send(level, message)
      end

      def log_request(method, url, headers, body)
        log(:debug, "KOBANA REQUEST: #{method.upcase} #{url}")
        log(:debug, "REQUEST HEADERS: #{headers.inspect}")
        log(:debug, "REQUEST BODY: #{body.inspect}") if body
      end

      def log_response(status, headers, body)
        log(:debug, "KOBANA RESPONSE: Status #{status}")
        log(:debug, "RESPONSE HEADERS: #{headers.inspect}")
        log(:debug, "RESPONSE BODY: #{body.inspect}")
      end

      def log_error(error)
        log(:error, "KOBANA ERROR: #{error.message}")
        log(:error, error.backtrace.join("\n")) if error.backtrace
      end

      def log_level_value(level)
        case level.to_sym
        when :debug then 0
        when :info then 1
        when :warn then 2
        when :error then 3
        else 4
        end
      end
    end
  end
end
