# Omniauth::DoximityOauth2

A [Doximity](http://www.doximity.com) OAuth2 Strategy for [OmniAuth](https://github.com/intridea/omniauth)

Doximity API Information at http://developer.doximity.com/oauth.html

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-doximity_oauth2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-doximity_oauth2

## Usage

1. Request OAuth Application Credentials from the Doximity team: http://developer.doximity.com/preferred/
1. Enable the Strategy
```ruby
# Rails
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :doximity,
           ENV['DOXIMITY_OAUTH_CLIENT_ID'],
           ENV['DOXIMITY_OAUTH_CLIENT_SECRET']
end
```

## Contributing

1. Fork it ( https://github.com/indiebrain/omniauth-doximity_oauth2/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
