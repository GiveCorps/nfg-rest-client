require "spec_helper"

describe NfgRestClient::AccessToken do
  let(:access_token) { NfgRestClient::AccessToken.new }

  it { validate_presence_of access_token, :userid }
  it { validate_presence_of access_token, :password }
  it { validate_presence_of access_token, :scope }

end