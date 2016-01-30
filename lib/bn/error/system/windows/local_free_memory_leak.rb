require "bn/error/system/windows"

module BN
  class Error < StandardError
    class System < Error
      class Windows < System
        # Raised when {Kernel32.local_free} can not free memory.
        class LocalFreeMemoryLeak < Windows
          def to_s
            "Local free memory leak."
          end
        end
      end
    end
  end
end
