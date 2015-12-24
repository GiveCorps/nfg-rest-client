require "spec_helper"

describe NfgRestClient::CreditCardPayment do
  let(:credit_card_payment) { NfgRestClient::CreditCardPayment.new(attributes) }
  let(:attributes) { credit_card_payment_params }
  it { validate_presence_of credit_card_payment, :source }
  it { validate_presence_of credit_card_payment, :donor }
  it { validate_presence_of credit_card_payment, :creditCard }
  it { validate_inclusion_of credit_card_payment, :source, { in: %w{CreditCard}}}

  describe "CreditCardDonor" do
    it "should instantiate a donor object if donor information is present and should validate it when validating the credit card payment object" do
      d = NfgRestClient::CreditCardDonor.new(donor_params)
      d.expects(:valid?).returns(true)
      NfgRestClient::CreditCardDonor.expects(:new).returns(d)
      credit_card_payment.valid?
    end
  end

  describe "CreditCard" do
    it "should instantiate a creditCard if credit card information is present and should validate it when validating the credit card payment object" do
      cc = NfgRestClient::CreditCard.new(credit_card_params)
      cc.expects(:valid?).returns(true)
      NfgRestClient::CreditCard.expects(:new).returns(cc)
      credit_card_payment.valid?
    end
  end

end

def credit_card_payment_params
  { "source" => "CreditCard",
    "donor" => donor_params,
    "creditCard" => credit_card_params
  }
end

def donor_params
  {
    "ip" => "216.7.145.0",
    "token" => "802f365c-ed3d-4c80-8700-374aee6ac62c",
    "firstName" => "Francis",
    "lastName" => "Carter",
    "email" => "FrancisGCarter@teleworm.us",
    "phone" => "954-922-6971",
    "billingAddress" => {
      "street1" => "3731 Pointe Lane",
      "city" => "Hollywood",
      "state" => "FL",
      "postalCode" => "33020",
      "country" => "US"
    }
  }
end

def credit_card_params
  {
    "nameOnCard" => "Francis G. Carter",
    "type" => "Visa",
    "number" => "4111111111111111",
    "expiration" => {
      "month" => 11,
      "year" => 2019
    },
    "securityCode" => "123"
  }
end