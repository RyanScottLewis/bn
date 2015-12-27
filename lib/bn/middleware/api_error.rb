require "bn/error/middleware/invalid_api_request"
require "bn/middleware/base"

module BN
  module Middleware
    # Checks the JSON API response to see if it is an error.
    class APIResponse < Base
      # Execute the middleware.
      #
      # @param [#to_h] data
      # @return [Hash]
      def execute(data)
        data = data.to_h

        raise BN::Error::Middleware::InvalidAPIRequest, data if error?(data)

        data
      end

      protected

      def error?(data)
        data.keys.sort == [:code, :reason].sort
      end
    end
  end
end
