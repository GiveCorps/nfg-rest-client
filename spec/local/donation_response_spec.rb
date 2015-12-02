require 'spec_helper'

describe NfgRestClient::Donation do
  include NfgRestClient::SpecAttributes
  include NfgRestClientStubs
  let(:donation) { NfgRestClient::Donation.new(donation_attributes(changes_to_attributes,  "underscore")) }
  describe "#create" do
    before do
      stub_successful_credit_card_donation
      donation.create
    end

    context "when the response is successful" do
      it "should have a status of 'Success'" do
        expect(donation.status).to eq("Success")
      end
    end
  end

end