require "bn/error/api"

module BN
  class Error < StandardError
    class API < Error
      # Raised when the key is invalid.
      class InvalidKey < API
        def to_s
          "The key is invalid."
        end
      end
    end
  end
end
