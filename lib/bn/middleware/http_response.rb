require "json"
require "httpi"
require "bn/error/middleware/invalid_http_response"
require "bn/middleware/base"

module BN
  module Middleware
    # Transforms the body of an HTTP request from JSON to Ruby.
    class HTTPResponse < Base
      # Execute the middleware.
      #
      # @param [#body] response
      # @return [Hash]
      def execute(response)
        raise Error::Middleware::InvalidHTTPResponse, response: response unless response.respond_to?(:body) && response.respond_to?(:code)

        body = response.body.to_s

        ::JSON.parse(body)
      end
    end
  end
end
