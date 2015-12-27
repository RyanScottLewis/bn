require "bn/api/base"

module BN
  module API
    # The the StarCraft 3 API requester.
    class SC3 < Base
      # Request a profile.
      #
      # @param [#to_h] options
      # @option options [#to_s] :id The ID of the profile.
      # @option options [#to_s] :region The region of the profile.
      # @option options [#to_s] :name The name of the profile
      # @return [HTTPI::Response]
      def profile(options={})
        get(profile_uri(options))
      end

      # Request a profile's ladders.
      #
      # @param [#to_h] options
      # @option options [#to_s] :id The ID of the profile.
      # @option options [#to_s] :region The region of the profile.
      # @option options [#to_s] :name The name of the profile
      # @return [HTTPI::Response]
      def ladders(options={})
        get(profile_uri(options, "ladders"))
      end

      # Request a profile's matches.
      #
      # @param [#to_h] options
      # @option options [#to_s] :id The ID of the profile.
      # @option options [#to_s] :region The region of the profile.
      # @option options [#to_s] :name The name of the profile
      # @return [HTTPI::Response]
      def matches(options={})
        get(profile_uri(options, "matches"))
      end

      # Request a ladder.
      #
      # @param [#to_h] options
      # @option options [#to_s] :id The ID of the ladder.
      # @return [HTTPI::Response]
      def ladder(options={})
        options = options.to_h

        get("/sc2/ladder/#{options[:id]}")
      end

      # Request achievements.
      #
      # @return [HTTPI::Response]
      def achievements
        get("/sc2/data/achievements")
      end

      # Request rewards.
      #
      # @return [HTTPI::Response]
      def achievements
        get("/sc2/data/rewards")
      end

      protected

      def profile_uri(options, path=nil)
        options = options.to_h

        "/sc2/profile/#{options[:id]}/#{options[:region]}/#{options[:name]}#{"/#{path}" unless path.nil?}"
      end
    end
  end
end
