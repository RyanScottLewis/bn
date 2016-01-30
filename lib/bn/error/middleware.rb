require "bn/error"

module BN
  class Error < StandardError
    # Base class for middleware errors.
    class Middleware < Error
    end
  end
end
