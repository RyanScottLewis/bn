require "bn/entity/base"
require "bn/entity/d3/hero"

module BN
  module Entity
    module D3
      # A profile within Diablo 3.
      class Profile < Base
        # @method battle_tag
        # Get the battle tag.
        #
        # @return [String]

        # @method battle_tag=
        # Set the battle tag.
        #
        # @param [#to_s] value
        # @return [String]
        attribute(:battle_tag) { |value| value.to_s.strip }

        # @method paragon_level
        # Get the paragon level.
        #
        # @return [Integer]

        # @method paragon_level=
        # Set the paragon level.
        #
        # @param [#to_i] value
        # @return [Integer]
        attribute(:paragon_level) { |value| value.to_i }

        # @method paragon_level_hardcore
        # Get the paragon hardcore level.
        #
        # @return [Integer]

        # @method paragon_level_hardcore=
        # Set the paragon hardcore level.
        #
        # @param [#to_i] value
        # @return [Integer]
        attribute(:paragon_level_hardcore) { |value| value.to_i }

        # @method paragon_level_season
        # Get the paragon season level.
        #
        # @return [Integer]

        # @method paragon_level_season=
        # Set the paragon season level.
        #
        # @param [#to_i] value
        # @return [Integer]
        attribute(:paragon_level_season) { |value| value.to_i }

        # @method paragon_level_season_hardcore
        # Get the paragon season hardcore level.
        #
        # @return [Integer]

        # @method paragon_level_season_hardcore=
        # Set the paragon season hardcore level.
        #
        # @param [#to_i] value
        # @return [Integer]
        attribute(:paragon_level_season_hardcore) { |value| value.to_i }

        # @method guild_name
        # Get the guild name.
        #
        # @return [String]

        # @method guild_name=
        # Set the guild name.
        #
        # @param [#to_s] value
        # @return [String]
        attribute(:guild_name) { |value| value.to_s }

        # @method heroes
        # Get the heroes.
        #
        # @return [<Hero>]

        # @method heroes=
        # Set the heroes.
        #
        # @param [#to_a] value
        # @return [<Hero>]
        attribute(:heroes) { |value| value.to_a.collect { |hero| convert_hero(hero) } }

        # @method last_hero_played
        # Get the last hero played.
        #
        # @return [Hero]

        # @method heroes=
        # Set the last hero played.
        #
        # @param [Hero, #to_h] value
        # @return [Hero]
        attribute(:last_hero_played) { |value| convert_hero(value) }

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

        # @method highest_hardcore_level
        # Get the highest hardcore level.
        #
        # @return [Integer]

        # @method highest_hardcore_level=
        # Set the highest hardcore level.
        #
        # @param [#to_i] value
        # @return [Integer]
        attribute(:highest_hardcore_level) { |value| value.to_i }

        # @method time_played
        # Get the time played.
        #
        # @return [Hash]

        # @method time_played=
        # Set the time played.
        #
        # @param [#to_h] value
        # @return [Hash]
        attribute(:time_played) { |value| value.to_h }

        # @method progression
        # Get the act progression.
        #
        # @return [Hash]

        # @method time_played=
        # Set the act progression.
        #
        # @param [#to_h] value
        # @return [Hash]
        attribute(:progression) { |value| value.to_h }

        # @method fallen_heroes
        # Get the fallen heroes.
        #
        # @return [<Hero>]

        # @method fallen_heroes=
        # Set the fallen heroes.
        #
        # @param [#to_a] value
        # @return [<Hero>]
        attribute(:fallen_heroes) { |value| value.to_a }

        protected

        def convert_hero(value)
          value.is_a?(Hero) ? value : Hero.new(value)
        end
      end
    end
  end
end
