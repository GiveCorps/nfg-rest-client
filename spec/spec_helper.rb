$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nfg-rest-client'
require 'nfg-rest-client/helpers/spec_helpers'

RSpec.configure do |config|
  config.mock_with :mocha
end

include NfgRestClient::ValidationHelpers

