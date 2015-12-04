require 'spec_helper'

shared_examples_for "a donation transaction" do
  context "when the response is successful" do
    let(:stub_the_transaction) { stub_successful_credit_card_donation }

    it "should have a status of 'Success'" do
      expect(donation.status).to eq("Success")
    end

    it "should return a chargeID" do
      expect(donation.chargeID).not_to eq(0)
    end
  end

  context "when the response indicates an unsuccessful transaction" do
    let(:stub_the_transaction) { stub_unsuccessful_credit_card_donation }
    it "should have a status that is not equal to 'Success'" do
      expect(donation.status).not_to eq("Success")
    end

    it "should have error details returned in a Flexirest::ResultIterator" do
      expect(donation.errorDetails).to be_a(Flexirest::ResultIterator)
    end

    it "should have a chargeId of 0" do
      expect(donation.chargeId).to eq(0)
    end
  end
end

describe NfgRestClient::Donation do
  include NfgRestClient::SpecAttributes
  include NfgRestClientStubs

  let(:donation) { NfgRestClient::Donation.new(donation_attributes(changes_to_attributes,  "underscore")) }

  context "using a credit card" do

    describe "#create" do
      before do
        stub_the_transaction
        donation.create
      end

      it_should_behave_like "a donation transaction"

    end
  end

  context "using a COF id" do
    let(:changes_to_attributes) { { "payment" => card_on_file_payment } }

    describe "#create" do
      before do
        stub_the_transaction
        donation.create
      end

      it_should_behave_like "a donation transaction"

    end
  end

end