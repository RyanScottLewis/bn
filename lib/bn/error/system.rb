require "bn/error"

module BN
  class Error < StandardError
    # Base class for system call errors.
    class System < Error
    end
  end
end
