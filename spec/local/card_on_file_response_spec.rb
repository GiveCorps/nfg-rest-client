require 'spec_helper'

describe NfgRestClient::CardOnFile do
  include NfgRestClient::SpecAttributes
  include NfgRestClientStubs

  let(:card_on_file) { NfgRestClient::CardOnFile.new(card_on_file_attributes) }


  describe "#create" do
    before do
      stub_the_transaction
      card_on_file.create
    end

    context "when the response is successful" do
      let(:stub_the_transaction) { stub_successful_card_on_file }

      it "should have a status of 'Success'" do
        expect(card_on_file.status).to eq("Success")
      end

      it "should return a cardOnFileId" do
        expect(card_on_file.cardOnFileId).not_to eq(0)
      end
    end

    context "when the response indicates an unsuccessful transaction" do
      let(:stub_the_transaction) { stub_unsuccessful_card_on_file }
      it "should have a status that is not equal to 'Success'" do
        expect(card_on_file.status).not_to eq("Success")
      end

      it "should have error details returned in a Flexirest::ResultIterator" do
        expect(card_on_file.errorDetails).to be_a(Flexirest::ResultIterator)
      end

      it "should have a cardOnFileId of 0" do
        expect(card_on_file.cardOnFileId).to eq(0)
      end
    end

  end
end