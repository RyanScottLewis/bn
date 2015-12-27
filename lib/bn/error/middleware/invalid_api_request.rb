require "bn/error/middleware/base"

module BN
  module Error
    module Middleware
      # Raised when the JSON API response was an error.
      class InvalidAPIRequest < Base
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
          "Invalid API request: #{@reason}."
        end
      end
    end
  end
end
