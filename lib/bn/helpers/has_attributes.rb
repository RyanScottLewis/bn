module BN
  module Helpers
    # Adds the `update_attributes` method and `attribute` class method.
    module HasAttributes
      # The class methods to be mixed in when included.
      module ClassMethods
        def attribute(name, options={}, &block)
          options = options.to_h

          attr_reader(name)

          define_method("#{name}=") do |value|
            value = instance_exec(value, options, &block) unless block.nil?

            instance_variable_set("@#{name}", value)
          end
        end
      end

      class << self
        def included(base)
          base.extend(ClassMethods)
        end
      end

      # Initialize this object by optionally updating attributes with a Hash.
      #
      # @param [#to_h] attributes Attributes to set after initializing.
      def initialize(attributes={})
        update_attributes(attributes)
      end

      # Update any attributes on this object.
      #
      # @param [#to_h] attributes
      # @return [Hash] The attributes.
      def update_attributes(attributes={})
        attributes = attributes.to_h
        attributes.each { |name, value| send("#{name}=", value) }

        attributes
      end
    end
  end
end
