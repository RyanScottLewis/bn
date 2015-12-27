require "bn/middleware/base"

module BN
  module Middleware
    # Recursively convert all keys in a Hash from camelCase or dashed-delimited Strings into underscore_delimited Symbols.
    class KeyConverter < Base
      # Execute the middleware.
      #
      # @param [#to_h] value
      # @return [Hash]
      def execute(value)
        convert_keys(value.to_h)
      end

      protected

      def convert_keys(data)
        data.keys.each do |key|
          value = data.delete(key)
          value = convert_keys(value) if value.is_a?(Hash)
          key = key.gsub(/([a-z\d])([A-Z])/, "\1_\2").tr("-", "_").downcase.to_sym

          data[key] = value
        end
      end
    end
  end
end
