require "aspect/has_attributes"

module BN
  # The base class for errors.
  class Error < StandardError
    include Aspect::HasAttributes

    def initialize(attributes={})
      update_attributes(attributes)
    end
  end
end
