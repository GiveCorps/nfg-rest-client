$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nfg-rest-client'
# require 'nfg-rest-client/helpers/spec_helpers'
require "ostruct"
require 'webmock/rspec'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  config.mock_with :mocha
end

include NfgRestClient::ValidationHelpers

