require "bn/error/system/windows"

module BN
  class Error < StandardError
    class System < Error
      class Windows < System
        # Raised when an error code given to {Kernel32.format_message} is invalid.
        class InvalidErrorCode < Windows
          # @method code
          # Get the error code.
          #
          # @return [Integer]

          # @method code=
          # Set the error code.
          #
          # @param [#to_i] value
          # @return [Integer]
          attribute(:code) { |value| value.to_i }

          def to_s
            "Invalid error code '#{@code}'."
          end
        end
      end
    end
  end
end
