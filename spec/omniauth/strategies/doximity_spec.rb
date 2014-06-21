require 'spec_helper'

describe OmniAuth::Strategies::Doximity do

  it 'provides the Doximity camelization' do
    expect(
      OmniAuth::Utils.camelize('doximity')
    ).to eq(
      'Doximity'
    )
  end

  subject(:strategy) do
    OmniAuth::Strategies::Doximity.new(nil)
  end

  describe '#name' do
    it 'is doximity' do
      expect(
        strategy.name
      ).to eq(
        'doximity'
      )
    end
  end

  describe '#client' do

    let(:client) do
      strategy.client
    end

    describe '#site' do
      it 'is the URL to the Doximity Site' do
        expect(
          client.site
        ).to eq(
         'http://www.doximity.com'
        )
      end
    end

    describe '#authorize_url' do
      it 'is the Doximity OAuth 2.0 authorization url' do
        expect(
          client.authorize_url
        ).to eq(
          'https://www.doximity.com/oauth/authorize'
        )
      end
    end

    describe '#token_url' do
      it 'is the Doximity User Access Token resource URL' do
        expect(
          client.token_url
        ).to eq(
          'https://www.doximity.com/oauth/token'
        )
      end
    end
  end

  describe '#callback_path' do
    it 'calls back to /auth/doximity/callback' do
      expect(
        strategy.callback_path
      ).to eq(
        '/auth/doximity/callback'
      )
    end
  end

  describe '#user_profile' do
    it 'is a parsed user profile response' do
      user_profile = {'id' => 'user_profile_id'}

      access_token = double(::OAuth2::AccessToken)
      response = double('response',
                        parsed: user_profile)

      expect(
        access_token
      ).to receive(:get).
      with('/api/v1/users/current').
      and_return(response)

      allow(
        strategy
      ).to receive(:access_token).
      and_return(access_token)

      expect(
        strategy.user_profile
      ).to eq(
        user_profile
      )
    end
  end

  describe '#uid' do
    it 'is user_profile id' do
      user_profile_id = 'user_profile_id'

      allow(
        strategy
      ).to receive(:user_profile).
      and_return({
        'id' => user_profile_id
      })

      expect(
        strategy.uid
      ).to eq(
        user_profile_id
      )
    end
  end

  describe '#info' do
    describe "['name']" do
      it 'is the user_profile full_name' do
        user_profile_name = 'user_profile_name'

        allow(strategy).
        to receive(:user_profile).
        and_return({
          'full_name' => user_profile_name
        })

        expect(
          strategy.info['name']
        ).to eq(
          user_profile_name
        )
      end
    end

    describe "['email']" do
      it 'is the user_profile email' do
        user_profile_email = 'user_profile_email'

        allow(strategy).
        to receive(:user_profile).
        and_return({
          'email' => user_profile_email
        })

        expect(
          strategy.info['email']
        ).to eq(
          user_profile_email
        )
      end
    end

    describe "['first_name']" do
      it 'is the user_profile first_name' do
        user_profile_first_name = 'user_profile_first_name'
        allow(strategy).
        to receive(:user_profile).
        and_return({
          'first_name' => user_profile_first_name
        })

        expect(
          strategy.info['first_name']
        ).to eq(
          user_profile_first_name
        )
      end
    end

    describe "['last_name']" do
      it 'is the user_profile last_name' do
        user_profile_last_name = 'user_profile_last_name'

        allow(strategy).
        to receive(:user_profile).
        and_return({
          'last_name' => user_profile_last_name
        })

        expect(
          strategy.info['last_name']
        ).to eq(
          user_profile_last_name
        )
      end
    end

    describe "['description']" do
      it 'is the user_profile description' do
        user_profile_description = 'user_profile_description'
        allow(strategy).
        to receive(:user_profile).
        and_return({
          'description' => user_profile_description
        })

        expect(
          strategy.info['description']
        ).to eq(
          user_profile_description
        )
      end
    end

    describe "['image']" do
      it 'is the user_profile profile_photo' do
        user_profile_profile_photo = 'user_profile_profile_photo'
        allow(strategy).
        to receive(:user_profile).
        and_return({
          'profile_photo' => user_profile_profile_photo
        })

        expect(
          strategy.info['image']
        ).to eq(
          user_profile_profile_photo
        )
      end
    end

    describe "['location']" do
      it 'is the location described by the user_profile' do
        user_profile_address_1 = 'user_profile_address_1'
        user_profile_address_2 = 'user_profile_address_2'
        user_profile_city      = 'user_profile_city'
        user_profile_state     = 'user_profile_state'
        user_profile_zip       = 'user_profile_zip'
        user_profile_country   = 'user_profile_country'

        allow(strategy).
        to receive(:user_profile).
        and_return({
          'address_1' => user_profile_address_1,
          'address_2' => user_profile_address_2,
          'city'      => user_profile_city,
          'state'     => user_profile_state,
          'zip'       => user_profile_zip,
          'country'   => user_profile_country
        })

        user_profile_location = [
                                  user_profile_address_1,
                                  user_profile_address_2,
                                  user_profile_city,
                                  user_profile_state,
                                  user_profile_zip,
                                  user_profile_country
                                ].join(' ')
        expect(
          strategy.info['location']
        ).to eq(
          user_profile_location
        )
      end
    end
  end

  describe '#extra' do
    it 'includes the raw user profile response' do
      user_profile = {
          'id' => 'user_profile_id'
      }

      allow(
        strategy
      ).to receive(:user_profile).
      and_return(user_profile)

      expect(
        strategy.extra
      ).to eq({
        'raw_info' => user_profile
      })
    end
  end

  describe '#authorize_params' do
    describe 'default' do
      describe 'redirect_url' do
        it 'is nil' do
          expect(
            strategy.authorize_params['redirect_uri']
          ).to be_nil
        end
      end

      describe 'scope' do
        it 'is basic' do
          expect(
            strategy.authorize_params['scope']
          ).to eq(
            'basic'
          )
        end
      end

      describe 'response_type' do
        it 'is code' do
          expect(
            strategy.authorize_params['response_type']
          ).to eq(
            'code'
          )
        end
      end

      describe 'type' do
        it 'is login' do
          expect(
            strategy.authorize_params['type']
          ).to eq(
            'login'
          )
        end
      end
    end
  end
end
