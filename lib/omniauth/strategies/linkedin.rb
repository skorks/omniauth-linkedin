require 'omniauth/strategies/oauth'

module OmniAuth
  module Strategies
    class LinkedIn < OmniAuth::Strategies::OAuth
      option :name, "linkedin"

      option :client_options, {
        :site => 'https://api.linkedin.com',
        :request_token_path => '/uas/oauth/requestToken',
        :access_token_path => '/uas/oauth/accessToken',
        :authorize_url => 'https://www.linkedin.com/uas/oauth/authenticate'
      }

      option :fields, ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location"]

      option :scope, 'r_basicprofile r_emailaddress'

      uid{ raw_info['id'] }

      info do
        name = [raw_info['firstName'], raw_info['lastName']].compact.join(' ').strip || nil
        name = nil_if_empty(name)
        {
          :name => name,
          :email => raw_info['emailAddress'],
          :nickname => name,
          :first_name => raw_info['firstName'],
          :last_name => raw_info['lastName'],
          :location => parse_location(raw_info['location']),
          :description => raw_info['headline'],
          :image => raw_info['pictureUrl'],
          :phone => nil,
          :headline => raw_info['headline'],
          :industry => raw_info['industry'],
          :urls => {
            'public_profile' => raw_info['publicProfileUrl']
          }
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        fields = options.fields
        fields.map! { |f| f == "picture-url" ? "picture-url;secure=true" : f } if options[:secure_image_url]
        @raw_info ||= MultiJson.decode(access_token.get("/v1/people/~:(#{fields.join(',')})?format=json").body)
      end

      def request_phase
        options.request_params ||= {}
        options.request_params[:scope] = options.scope.gsub("+", " ")
        super
      end

      private

      def parse_location(location_hash = {})
        location_hash ||= {}
        location_name = extract_location_name(location_hash)
        country_code = extract_country_code(location_hash)
        build_location_value(location_name, country_code)
      end

      def extract_location_name(location_hash = {})
        nil_if_empty(location_hash["name"])
      end

      def extract_country_code(location_hash = {})
        country_hash = location_hash["country"] || {}
        country_code = nil_if_empty(country_hash["code"])
        country_code = (country_code ? country_code.upcase : nil)
      end

      def build_location_value(location_name, country_code)
        nil_if_empty([location_name, country_code].compact.join(', '))
      end

      def nil_if_empty(value)
        (value.nil? || value.empty?) ? nil : value
      end
    end
  end
end

OmniAuth.config.add_camelization 'linkedin', 'LinkedIn'

