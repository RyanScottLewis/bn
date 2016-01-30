require "bn/error/system"

module BN
  class Error < StandardError
    class System < Error
      # Base class for Windows system call errors.
      class Windows < System
      end
    end
  end
end
