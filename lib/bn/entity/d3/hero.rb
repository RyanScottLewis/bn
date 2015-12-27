require "bn/entity/base"

module BN
  module Entity
    module D3
      # A hero within Diablo 3.
      class Hero < Base
        MAX_LEVEL = 70

        def initialize(attributes={})
          super

          @level ||= 1
          @paragon_level ||= 0
          @hardcore ||= false
          @seasonal ||= false
          @dead ||= false
        end

        # @method id
        # Get the ID.
        #
        # @return [Integer]

        # @method id=
        # Set the ID.
        #
        # @param [#to_i] value
        # @return [Integer]
        attribute(:id) { |value| value.to_i }

        # @method name
        # Get the name.
        #
        # @return [String]

        # @method name=
        # Set the name.
        #
        # @param [#to_s] value
        # @return [String]
        attribute(:name) { |value| value.to_s.strip }

        # @method hero_class
        # Get the hero class.
        #
        # @return [Symbol]

        # @method hero_class=
        # Set the hero class.
        #
        # @param [#to_sym] value
        # @return [Symbol]
        attribute(:hero_class) { |value| value.to_sym }

        # @method gender
        # Get the gender.
        #
        # @return [Symbol]

        # @method gender=
        # Set the gender.
        #
        # @param [#to_sym] value
        # @return [Symbol]
        attribute(:gender) { |value| value.to_sym }

        # @method level
        # Get the level.
        #
        # @return [Integer]

        # @method level=
        # Set the level.
        #
        # @param [#to_i] value
        # @return [Integer]
        attribute(:level) { |value| validate_level(value) }

        # @method paragon_level
        # Get the paragon level.
        #
        # @return [Integer]

        # @method paragon_level=
        # Set the paragon level.
        #
        # @param [#to_i] value
        # @return [Integer]
        attribute(:paragon_level) { |value| validate_level(value, true) }

        # @method kills
        # Get the number of kills per enemy type.
        #
        # @return [Hash]

        # @method kills=
        # Set the number of kills per enemy type.
        #
        # @param [#to_h] value
        # @return [Hash]
        attribute(:kills) { |value| value.to_h }

        # @method hardcore
        # Get whether this hero is hardcore.
        #
        # @return [Boolean]

        # @method hardcore=
        # Set whether this hero is hardcore.
        #
        # @param [Boolean] value
        # @return [Boolean]
        attribute(:hardcore) { |value| !!value }

        # @method seasonal
        # Get whether this hero is seasonal.
        #
        # @return [Boolean]

        # @method seasonal=
        # Set whether this hero is seasonal.
        #
        # @param [Boolean] value
        # @return [Boolean]
        attribute(:seasonal) { |value| !!value }

        # @method last_updated
        # Get the last updated time.
        #
        # @return [Time]

        # @method last_updated=
        # Set the last updated time.
        #
        # @param [Time, #to_i] value
        # @return [Time]
        attribute(:last_updated) { |value| convert_time(value) }

        # @method dead
        # Get whether this hero is dead.
        #
        # @return [Boolean]

        # @method dead=
        # Set whether this hero is dead.
        #
        # @param [Boolean] value
        # @return [Boolean]
        attribute(:dead) { |value| !!value }

        protected

        def validate_level(value, paragon=false)
          value = value.to_i
          value = 0 if value < MAX_LEVEL
          value = MAX_LEVEL if !paragon && value > MAX_LEVEL

          value
        end
      end
    end
  end
end
