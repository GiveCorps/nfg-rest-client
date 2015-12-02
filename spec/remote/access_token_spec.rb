require 'spec_remote_helper'

describe NfgRestClient::AccessToken, allow_net_connect: true  do
  let(:access_token) { NfgRestClient::AccessToken.new }
  describe "#create" do
    context "when the response is successful" do
      it "should have a status of 'Success'" do
        pending("this test should only be run once to generate a token.")
        raise "this is to ensure the remaining lines dont run"
        # to run this test, comment out the 2 lines above then run 'rspec spec/remote/access_token'
        # The token will be outputed (using the p statement below) in your test results
        # Once you have generated the token, copy it to your spec_remote_helper and uncomment the pending statement
        access_token.create
        expect(access_token.status).to eq("Success")
        expect(access_token.token).to be
        p access_token.token
      end
    end
  end

end