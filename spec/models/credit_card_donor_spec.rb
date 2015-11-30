require 'spec_helper'

describe NfgRestClient::CreditCardDonor do
  let(:donor) { NfgRestClient::CreditCardDonor.new(attributes) }
  let(:attributes) { donor_params }

  it { validate_presence_of donor, :ip }
  it { validate_presence_of donor, :firstName }
  it { validate_presence_of donor, :lastName }
  it { validate_presence_of donor, :billingAddress }
  it { validate_presence_of donor, :token }
  it { validate_presence_of donor, :email }

  it "should instantiate the billing address" do
    ba = NfgRestClient::BillingAddress.new(billing_address_params)
    ba.expects(:valid?).returns(true)
    NfgRestClient::BillingAddress.expects(:new).returns(ba)
    donor.valid?
  end

end

def donor_params
  {
    "ip" => "216.7.145.0",
    "token" => "802f365c-ed3d-4c80-8700-374aee6ac62c",
    "firstName" => "Francis",
    "lastName" => "Carter",
    "email" => "FrancisGCarter@teleworm.us",
    "phone" => "954-922-6971",
    "billingAddress" => billing_address_params
  }
end

def billing_address_params
  {
    "street1" => "3731 Pointe Lane",
    "city" => "Hollywood",
    "state" => "FL",
    "postalCode" => "33020",
    "country" => "US"
  }
end