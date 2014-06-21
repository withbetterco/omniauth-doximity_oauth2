require 'bundler/setup'
Bundler.setup

require 'simplecov'
SimpleCov.start

require 'omniauth/doximity_oauth2'

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.order = 'random'
end
