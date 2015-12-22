require "spec_helper"

describe NfgRestClient::CardOnFile do
  include NfgRestClient::SpecAttributes
  let(:card_on_file) { NfgRestClient::CardOnFile.new(attributes) }
  let(:attributes) { card_on_file_attributes }

  it { validate_presence_of card_on_file, :donor }
  it { validate_presence_of card_on_file, :credit_card }

  it "should instantiate the donor model" do
    donor = NfgRestClient::CreditCardDonor.new(donation_donor_attributes)
    NfgRestClient::CreditCardDonor.expects(:new).returns(donor)
    card_on_file
  end

  it "should instantiate the credit card model" do
    credit_card = NfgRestClient::CreditCard.new(donation_credit_card_attributes)
    NfgRestClient::CreditCard.expects(:new).returns(credit_card)
    expect(card_on_file.creditCard).to eq(credit_card)
  end

end