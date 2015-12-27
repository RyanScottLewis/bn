require "httpi"
require "bn/helpers/has_attributes"
require "bn/error/api/invalid_key"
require "bn/error/api/invalid_region"
require "bn/error/api/invalid_locale"

module BN
  module API
    # The base class for API requesters.
    class Base
      include Helpers::HasAttributes

      def initialize(attributes={})
        self.region = :us

        super

        raise Error::API::InvalidKey if @key.nil?
      end

      attribute(:key) { |value| validate_key(value) }

      attribute(:region) { |value| validate_and_convert_region(value) }

      attribute(:locale) { |value| validate_locale(value) }

      protected

      # Send an HTTP GET request.
      #
      # @param [#to_s] url
      # @param [#to_h] query
      # @return [HTTPI::Response]
      def get(url, query={})
        url = url.to_s.gsub(%r{^/}, "")
        query = query.to_h

        request = HTTPI::Request.new
        request.url = "#{@region[:host]}/#{url}"
        request.query = { apikey: @key, locale: @locale }.merge(query)

        HTTPI.get(request)
      end

      def validate_key(value)
        value = value.to_s.delete(" ")

        raise Error::API::InvalidKey if value.empty?

        value
      end

      def validate_and_convert_region(region_key)
        region_key = region_key.to_sym

        raise Error::API::InvalidRegion unless BN::API::REGIONS.keys.include?(region_key)

        region = REGIONS[region_key]
        @locale = region[:locales].first

        region
      end

      def validate_locale(locale)
        locale = locale.to_s.strip
        locale = @region[:locales].first if locale.empty?

        raise Error::API::InvalidLocale, region: @region unless @region[:locales].include?(locale)

        locale
      end

      def sanitize_battle_tag(value)
        value.to_s.delete(" ").gsub(/#/, "-")
      end
    end
  end
end
