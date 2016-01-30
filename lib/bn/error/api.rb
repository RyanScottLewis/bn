require "bn/error"

module BN
  class Error < StandardError
    # Base class for API errors.
    class API < Error
    end
  end
end
