require "bn/error/system/windows"

module BN
  class Error < StandardError
    class System < Error
      class Windows < System
        # Raised when a process identifier is invalid.
        class InvalidPID < Windows
          def to_s
            "Invalid pid"
          end
        end
      end
    end
  end
end
