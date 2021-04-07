require 'spec_helper'

describe NfgRestClient::CreditCard do
  let(:credit_card) { NfgRestClient::CreditCard.new(attributes) }
  let(:attributes) { credit_card_attributes }

  it { validate_presence_of credit_card, :nameOnCard }
  it { validate_presence_of credit_card, :type }
  it { validate_presence_of credit_card, :number }
  it { validate_presence_of credit_card, :expiration }
  it { validate_presence_of credit_card, :securityCode }
  it { validate_inclusion_of credit_card, :type, { in: %w{Visa Mastercard Amex Discover} } }

  describe "sub model instantiation" do
    context "when the attributes contain expiration values" do
      it "should instantiate the ExpirationDate model" do
        expiration = NfgRestClient::ExpirationDate.new(credit_card_attributes["expiration"])
        NfgRestClient::ExpirationDate.expects(:new).once.returns(expiration)
        credit_card
      end

      it "should validate the expiration date model" do
        NfgRestClient::ExpirationDate.any_instance.expects(:valid?).returns(true)
        credit_card.valid?
      end
    end

    context "when the attributes do not contain expiration values" do
      let(:attributes) { credit_card_attributes.delete_if { |k, v| k == "expiration" } }
      it "should not instantiate the ExpirationDate model" do
        NfgRestClient::ExpirationDate.expects(:new).never
        credit_card
      end

      it "should not attempt to validate the expiration date model" do
        NfgRestClient::ExpirationDate.any_instance.expects(:valid?).never
        credit_card.valid?
      end
    end
  end
end

def credit_card_attributes
  {
   "nameOnCard" => "Francis G. Carter",
   "type" => "Visa",
   "number" => "4111111111111111",
   "expiration" => {
       "month" => 13,
       "year" => 2019
     },
   "securityCode" => "123"
   }
end