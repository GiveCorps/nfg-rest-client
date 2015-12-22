require 'spec_remote_helper'

describe NfgRestClient::Donation  do
  include NfgRestClient::SpecAttributes
  let(:donation) { NfgRestClient::Donation.new(donation_attributes(changes_to_attributes,  "underscore")) }
  let(:charged_id_regex) { /^\d{10}$/ }
  describe "#create" do
    before do
    end

    context "when the response is successful" do
      it "should have a status of 'Success' and return a chargeID with a non-zero value" do
        donation.create
        expect(donation.status).to eq("Success")
        expect(donation.chargeId.to_s).to match(charged_id_regex)
        expect(donation.cardOnFileId).to eq(0)
      end
    end

    context "when the response is not successful" do
      let(:security_code) { '301' } # a security code in the 300-600 range will result in an error
      it "should not have a status of success and not return an chargeID" do
        donation.create
        expect(donation.status).not_to eq("Success")
        expect(donation.chargeId).not_to be_blank
        expect(donation.chargeId.to_s).not_to eq('0')
      end
    end

    context "when attempting a charge and requesting a card on file be returned" do
      let(:donation) { NfgRestClient::Donation.new(donation_attributes(changes_to_attributes,  "underscore")).tap { |d| d.payment.storeCardOnFile = true } }

      context "when the response is successful" do
        it "should have a status of 'Success' and return a chargeID with a non-zero value" do
          donation.create
          expect(donation.status).to eq("Success")
          expect(donation.chargeId.to_s).to match(charged_id_regex)
          expect(donation.cardOnFileId.to_s).to match(/^\d{7}$/) #7 digit number
        end
      end
    end

    context "when attempting a charge where a line item is to have a fee added" do
      let(:add_or_deduct_1) { "Add" }
      let(:add_or_deduct_fee_amount) { "0.75" }
      let(:total_amount) { "100.75" }
      let(:changes_to_attributes) { { "add_or_deduct_fee_amount" => add_or_deduct_fee_amount } }

      context "and the attempt is successful" do
        it "should have a status of success and return a chargeID with a non-zero value" do
          donation.create
          expect(donation.status).to eq("Success")
          expect(donation.chargeId.to_s).to match(charged_id_regex)
        end
      end

    end

    context "when attempting to use a previously saved card on file" do
      let(:changes_to_attributes) { { "payment" => card_on_file_payment } }
      let(:card_on_file_id) { @card_on_file_id }

      before do
        card_on_file =  NfgRestClient::CardOnFile.new(card_on_file_attributes)
        card_on_file.create
        @card_on_file_id = card_on_file.cardOnFileId
      end

      context "and the attempt is successful" do
        it "should have a status of success and return a chargeID with a non-zero value" do
          donation.create
          expect(donation.status).to eq("Success")
          expect(donation.chargeId.to_s).to match(charged_id_regex)
        end
      end
    end
  end

end