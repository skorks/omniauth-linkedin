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

      option :fields, ["id", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url"]

      uid{ raw_info['id'] }

      info do
        {
          :first_name => raw_info['firstName'],
          :last_name => raw_info['lastName'],
          :name => "#{raw_info['firstName']} #{raw_info['lastName']}",
          :headline => raw_info['headline'],
          :image => raw_info['pictureUrl'],
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
        @raw_info ||= MultiJson.decode(access_token.get("/v1/people/~:(#{options.fields.join(',')})?format=json").body)
      end
    end
  end
end

OmniAuth.config.add_camelization 'linkedin', 'LinkedIn'

