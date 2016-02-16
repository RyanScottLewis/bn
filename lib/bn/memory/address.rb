require "aspect/has_attributes"

module BN
  module Memory
    # Additive memory address dictionary tree with dynamic method getters and setters.
    # TODO: Documentation
    # TODO: Add recursively add children from hash to be able to load from file instead of defining in code in Memory::D3
    class Address
      include Enumerable
      include Aspect::HasAttributes

      def initialize(attributes={})
        @children = []
        @offset = 0
        @size = 4 # 4 = int, 8 = long

        update_attributes(attributes)

        raise ArgumentError, "name must be given" if @name.nil?
      end

      # @method name
      # Get the name of this address.
      #
      # @return [Symbol]

      # @method name=
      # Set the name of this address.
      #
      # @param [Symbol, #to_s] value
      # @return [Symbol]
      attribute(:name) { |value| sanitize_name(value) }

      # @method offset
      # Get the offset of this address.
      #
      # @return [Integer]

      # @method offset=
      # Set the offset of this address.
      # Must be 0 or greater.
      #
      # @param [#to_i] value
      # @return [Integer]
      attribute(:offset) { |value| sanitize_offset_and_size(value) }

      # @method size
      # Get the size of this address.
      #
      # @return [Integer]

      # @method size=
      # Set the size of this address.
      # Must be 0 or greater.
      #
      # @param [#to_i] value
      # @return [Integer]
      attribute(:size) { |value| sanitize_offset_and_size(value) }

      # @method parent
      # Get the parent of this address.
      #
      # @return [Address]

      # @method parent=
      # Set the parent of this address.
      #
      # @param [Address] value
      # @return [parent]
      attribute(:parent) { |value| sanitize_parent(value) }

      # TODO: When `["foo.bar.bar"] = { offset: 123, size: 32 }` then it should recursively create foo.bar when they dont exist
      def set_child(name, attributes={})
        name = sanitize_name(name)

        child = find_child_by_name(name)
        child = create_child_by_name(name) if child.nil?

        child.update_attributes(attributes)

        child
      end
      alias_method :[]=, :set_child

      def delete_child(name) # TODO: Remove method
        child = find_child_by_name(name)
        return if child.nil?

        @children.delete(child)
      end

      def find_child(query)
        child = find_child_by_name(query)
        return child unless child.nil?

        find_child_by_query(query)
      end

      def find_child_by_name(name)
        name = sanitize_name(name)

        @children.find { |child| child.name == name }
      end

      def find_child_by_query(query)
        query = sanitize_query(query)

        return if query.nil?

        query.split(".").inject(self) do |memo, name|
          break if memo.nil?

          memo.find_child_by_name(name)
        end
      end

      def +(other)
        to_i + other
      end

      def each(&block)
        @children.each(&block)
      end

      # Absolute position
      def to_i(index=0)
        offset = @offset + (@size * index)

        @parent.nil? ? offset : @parent.to_i + offset
      end

      def to_s(index=0)
        "0x" + to_i(index).to_s(16)
      end

      def method_missing(name, *arguments)
        raise ArgumentError, "wrong number of arguments (#{arguments.length} for 0..1)" if arguments.length > 1
        set_child(name, arguments[0]) if arguments.length == 1

        self.set_child(name)
      end

      protected

      def sanitize_name(value)
        value.is_a?(Symbol) ? value : value.to_s.strip.downcase.to_sym
      end

      def sanitize_offset_and_size(value)
        value = value.to_i
        value = 0 if value < 0

        value
      end

      def sanitize_parent(value)
        raise TypeError, "parent must be an instance of BN::Memory::Address" unless value.is_a?(Address)

        value
      end

      def sanitize_query(value)
        value = value.to_s.strip.downcase

        value =~ /\./ ? value : nil
      end

      def create_child_by_name(name)
        child = Address.new(name: name, parent: self)
        @children << child

        (class << self; self; end).instance_eval do
          define_method(name) { child }
        end

        child
      end
    end
  end
end
