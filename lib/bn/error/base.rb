require "bn/helpers/has_attributes"

module BN
  module Error
    # The base class for errors.
    class Base < StandardError
      include Helpers::HasAttributes
    end
  end
end
