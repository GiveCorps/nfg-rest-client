require 'spec_remote_helper'

describe NfgRestClient::Donation  do
  include NfgRestClient::SpecAttributes
  let(:card_on_file) { NfgRestClient::CardOnFile.new(card_on_file_attributes) }
  describe "#create" do
    before do
      card_on_file.create
    end

    context "when the response is successful" do
      it "should have a status of 'Success'" do
        expect(card_on_file.status).to eq("Success")
        expect(card_on_file.cardOnFileId).not_to be_blank
      end
    end
  end

end