require 'spec_remote_helper'

describe NfgRestClient::Donation  do
  include NfgRestClient::SpecAttributes
  let(:donation) { NfgRestClient::Donation.new(donation_attributes(changes_to_attributes,  "underscore")) }
  describe "#create" do
    before do
      donation.create
    end

    context "when the response is successful" do
      it "should have a status of 'Success'" do
        expect(donation.status).to eq("Success")
        expect(donation.chargeId).to
      end
    end
  end

end