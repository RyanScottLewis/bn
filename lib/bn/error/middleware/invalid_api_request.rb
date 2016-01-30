require "bn/error/middleware"

module BN
  class Error < StandardError
    class Middleware < Error
      # Raised when the JSON API response was an error.
      class InvalidAPIRequest < Middleware
        # @method code
        # Get the code for this API error.
        #
        # @return [String]

        # @method code=
        # Set the code for this API error.
        #
        # @param [#to_s] value
        # @return [String]
        attribute(:code) { |value| value.to_s }

        # @method reason
        # Get the reason for this API error.
        #
        # @return [String]

        # @method reason=
        # Set the reason for this API error.
        #
        # @param [#to_s] value
        # @return [String]
        attribute(:reason) { |value| value.to_s }

        def to_s
          "Invalid API request: #{@code} - #{@reason}."
        end
      end
    end
  end
end
