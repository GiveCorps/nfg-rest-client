$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'nfg-rest-client'

require 'byebug'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  config.mock_with :mocha
end

# To run these remote tests, replace the dummy values with your sandbox credentials from NFG
Flexirest::Logger.logfile = Dir.pwd + "/nfg.log"
NfgRestClient::Base.password = "qAAJ6yWN"
NfgRestClient::Base.userid =  "G!V3C0RP5"
NfgRestClient::Base.source = "GCORPS"

# To run anything other than the access token calls you will need to have runn the AccessToken call and add the token here.
NfgRestClient::Base.token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6InpXOW4tazFiRU5Wd085RldsSTVUQ00yYzd4MCIsImtpZCI6InpXOW4tazFiRU5Wd085RldsSTVUQ00yYzd4MCJ9.eyJjbGllbnRfaWQiOiJHIVYzQzBSUDUiLCJjbGllbnRfcGFydG5lcl9pZCI6IjEwMDk1NSIsImNsaWVudF9jYXBhYmlsaXRpZXMiOlsiNSIsIjciLCI4IiwiOSIsIjEwIiwiMTEiLCIxMiIsIjEzIiwiMTUiLCIxOSJdLCJjbGllbnRfY2FtcGFpZ25DYXBhYmlsaXRpZXMxMTI2MCI6WyIwIiwiMSIsIjUiLCI5Il0sImNsaWVudF9jYW1wYWlnbkNhcGFiaWxpdGllczExMjc5IjpbIjEiLCI0IiwiNSJdLCJzY29wZSI6WyJkb25hdGlvbiIsImRvbmF0aW9uLXJlcG9ydGluZyJdLCJqdGkiOiJjM2I1MjNmYzhmN2JjY2ZjMmUyMTYxNjJlMzAxZTZjNCIsImlzcyI6Imh0dHBzOi8vaWRlbnRpdHktbmZnLXNhbmRib3gubmZncHJvZC5vcmciLCJhdWQiOiJodHRwczovL2lkZW50aXR5LW5mZy1zYW5kYm94Lm5mZ3Byb2Qub3JnL3Jlc291cmNlcyIsImV4cCI6MTYwNjg4MTQwNywibmJmIjoxNDQ5MDkzNDA3fQ.kiOqTdawtxwnDDy2eYlGjgSdSeaGeStR73b2wzGoc-HVtXs5yU3vaHfNd8Si-pw-Uh-qEOkqU6tl90-2ckaYBYCMfMWkVQ1Ma3WBiwhP5TvZ1eAkc1_d9WBtwlbiWBO3z_86ke23CQ5RDfi8aYwGtV9P3gBX1Ih5pvJ8_y1of0GlcP1txlR2AFJlNmcct-st_zu-K1jCDeKkhQHhTKbzadxqmA_NRg0kw68lqIULHah5EmHxrprChogg95axPaBA9MsOzU1E6L8HpqOVIdwfReb4fxVsHNPzOk9lySeTecCYNA-5hDeduGD0Hn-myap57R9w78nbG24ud0YP3efHZQ"