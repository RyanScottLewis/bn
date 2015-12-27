module BN
  module Middleware
    # The base class for middleware.
    class Base
      class << self
        def execute(data, options={})
          new(options).execute(data)
        end
      end

      def initialize(options={})
        @options = options.to_h
      end

      # Execute the middleware.
      def execute(_value)
        raise NotImplementedError
      end
    end
  end
end
