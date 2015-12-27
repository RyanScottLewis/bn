module BN
  # The API response middleware.
  module Middleware
    class << self
      def execute(data, *middleware)
        middleware.each_with_object(data) { |middleware, data| middleware.execute(data, options) }
      end
    end
  end
end

require "bn/middleware/http_response"
require "bn/middleware/d3"
