require "bn/api/base"

module BN
  module API
    # The the Diablo 3 API requester.
    class D3 < Base
      # Request a profile.
      #
      # @param [#to_h] options
      # @option options [#to_s] :battle_tag The battle tag.
      # @return [HTTPI::Response]
      def profile(options={})
        options = options.to_h

        battle_tag = sanitize_battle_tag(options.delete(:battle_tag))

        get("/d3/profile/#{battle_tag}", options)
      end

      # Request a hero.
      #
      # @param [#to_h] options
      # @option options [#to_s] :battle_tag The battle tag.
      # @option options [#to_s] :id The hero's ID.
      # @return [HTTPI::Response]
      def hero(options={})
        options = options.to_h

        battle_tag = sanitize_battle_tag(options.delete(:battle_tag))
        id = sanitize_id(options.delete(:id))

        get("/d3/profile/#{battle_tag}/hero/#{id}", options)
      end

      protected

      def sanitize_id(id)
        id = id.to_s.gsub(/[^0-9]/, "") unless id.is_a?(Integer)

        id.to_i
      end
    end
  end
end
