require "bn/error/api/base"

module BN
  module Error
    module API
      # Raised when the locale is invalid.
      class InvalidLocale < Base
        attribute(:region)

        def to_s
          "Invalid locale for region '#{@region[:name]}'. Must be one of the following: #{@region[:locales]}"
        end
      end
    end
  end
end
