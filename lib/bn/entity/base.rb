require "bn/helpers/has_attributes"

module BN
  module Entity
    # The base class for game entities.
    class Base
      include Helpers::HasAttributes

      protected

      def convert_time(value)
        value.is_a?(Time) ? value : Time.at(value.to_i)
      end
    end
  end
end
