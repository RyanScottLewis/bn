require "bn/error/api/base"

module BN
  module Error
    module API
      # Raised when the key is invalid.
      class InvalidKey < Base
        def to_s
          "The key is invalid."
        end
      end
    end
  end
end
