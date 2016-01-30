require "bn/error/middleware"

module BN
  class Error < StandardError
    class Middleware < Error
      # Raised when the HTTP response object given is invalid.
      class InvalidHTTPResponse < Middleware
        # @method response
        # Get the HTTP response.
        #
        # @return [#body]

        # @method response=
        # Set the HTTP response.
        #
        # @param [#body] value
        # @return [#body]
        attribute(:response)

        def to_s
          "Invalid HTTP response."
        end
      end
    end
  end
end
