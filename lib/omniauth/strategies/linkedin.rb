require 'omniauth/strategies/oauth'

module OmniAuth
  module Strategies
    class LinkedIn < OmniAuth::Strategies::OAuth

      option :name, "linkedin"

      option :client_options, {
        :site => 'https://api.linkedin.com',
        :access_token_path => '/uas/oauth/accessToken',
        :authorize_url => 'https://www.linkedin.com/uas/oauth/authenticate'
      }

      # The default scope provides just enough information to satisfy the requirements
      option :scope, 'r_basicprofile+r_emailaddress'

      # These fields will be fetched by default
      option :fields, ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location"]

      uid{ raw_info['id'] }

      info do
        {
          :email => raw_info['emailAddress'],
          :first_name => raw_info['firstName'],
          :last_name => raw_info['lastName'],
          :name => "#{raw_info['firstName']} #{raw_info['lastName']}",
          :description => raw_info['headline'],
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

      def request_phase
        options.client_options.request_token_path = '/uas/oauth/requestToken?scope=' + options.scope

        super
      end
    end
  end
end

OmniAuth.config.add_camelization 'linkedin', 'LinkedIn'

