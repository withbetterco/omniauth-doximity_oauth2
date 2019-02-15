module OmniAuth
  module Strategies
    class Doximity < OmniAuth::Strategies::OAuth2

      option :name, 'doximity'
      option :client_options, {
        site: 'https://www.doximity.com',
        authorize_url: 'https://auth.doximity.com/oauth/authorize',
        token_url: 'https://auth.doximity.com/oauth/token'
      }

      option :authorize_params, {
        type: 'login',
        response_type: 'code',
        scope: 'basic'
      }

      def user_profile
        @user_profile ||= access_token.
                            get('/api/v1/users/current').
                            parsed
      end

      uid do
        user_profile['id']
      end

      info do
        {
          'name'        => user_profile['full_name'],
          'email'       => user_profile['email'],
          'first_name'  => user_profile['first_name'],
          'last_name'   => user_profile['last_name'],
          'description' => user_profile['description'],
          'image'       => user_profile['profile_photo'],
          'location'    => [
            user_profile['address_1'],
            user_profile['address_2'],
            user_profile['city'],
            user_profile['state'],
            user_profile['zip'],
            user_profile['country']
          ].reject(&:nil?).join(' ')
        }
      end

      extra do
        {
          'raw_info' => user_profile
        }
      end
    end
  end
end

OmniAuth.config.add_camelization 'doximity', 'Doximity'
