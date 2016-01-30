require "bn/error/api"

module BN
  class Error < StandardError
    class API < Error
      # Raised when the locale is invalid.
      class InvalidLocale < API
        # @method region
        # Get the region.
        #
        # @return [nil, Hash]

        # @method region=
        # Set the region.
        #
        # @param [#to_h]
        # @return [Hash]
        attribute(:region) { |value| value.to_h }

        def to_s
          "Invalid locale for region '#{@region[:name]}'. Must be one of the following: #{@region[:locales]}"
        end
      end
    end
  end
end
