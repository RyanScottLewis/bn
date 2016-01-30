require "bn/error/api"
require "bn/api"

module BN
  class Error < StandardError
    class API < Error
      # Raised when the region is invalid.
      class InvalidRegion < API
        def to_s
          "Region must be one of the following: #{BN::API::REGIONS.keys}"
        end
      end
    end
  end
end
