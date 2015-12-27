require "bn/middleware/base"
require "bn/entity/d3/profile"

module BN
  module Middleware
    module D3
      # Transforms a Hash into an Entity::Profile instance.
      class Profile < Base
        # Execute the middleware.
        #
        # @return [Entity::Profile]
        def execute(data)
          convert_heroes(data)
          convert_time_played(data)

          Entity::D3::Profile.new(data)
        end

        protected

        def convert_heroes(data)
          data[:heroes].each do |hero|
            hero[:hero_class] = hero.delete(:class).tr("-", "_").downcase.to_sym
            hero[:gender] = hero[:gender] == 0 ? :male : :female
          end
        end

        def convert_time_played(data)
          data[:time_played].keys.each do |hero_class|
            value = data[:time_played].delete(hero_class).to_f
            hero_class = hero_class.tr("-", "_").downcase.to_sym

            hero[hero_class] = value
          end
        end
      end
    end
  end
end
