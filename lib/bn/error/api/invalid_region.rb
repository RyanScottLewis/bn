require "bn/error/api/base"

module BN
  module Error
    module API
      # Raised when the region is invalid.
      class InvalidRegion < Base
        def to_s
          "Region must be one of the following: #{BN::API::REGIONS.keys}"
        end
      end
    end
  end
end
