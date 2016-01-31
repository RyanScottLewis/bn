require "bn/error/system/windows"

module BN
  class Error < StandardError
    class System < Error
      class Windows < System
        # Raised when a process could not be opened.
        class OpenProcessFailure < Windows
          attribute(:message) { |value| value.to_s }

          def to_s
            "Could not open process: #{message}."
          end
        end
      end
    end
  end
end
