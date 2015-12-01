require "spec_helper"

describe NfgRestClient::BillingAddress do
  let(:billing_address) { NfgRestClient::BillingAddress.new(billing_address_params) }
  let(:attributes) { billing_address_params }
  let(:state) { "FL" }
  let(:country) { "US" }

  it { validate_presence_of billing_address, :street1 }
  it { validate_presence_of billing_address, :city }
  it { validate_presence_of billing_address, :state }
  it { validate_presence_of billing_address, :postalCode }
  it { validate_presence_of billing_address, :country }
  it { validate_inclusion_of billing_address, :country, { in: NfgRestClient::CountryState::COUNTRY_CODES } }

  context "when the country is US" do
    context "and the state is not in the list of ansi 2 character codes" do
      let(:state) { "XX" }
      it "should not be valid" do
        expect(billing_address).not_to be_valid
      end
    end

    context "and the state is in the list of ansi 2 character codes" do
      it "should be valid" do
        expect(billing_address).to be_valid
      end
    end
  end

  context "when the country is not the US" do
    let(:country) { 'AW' }
    context "and the state is not in the list of ansi 2 character codes" do
      let(:state) { 'YY' }
      it "should be valid" do
        expect(billing_address).to be_valid
      end
    end
  end

  context "when the country is downcased from a valid entry" do
    let(:country) { 'us' }
    it "should be valid" do
      expect(billing_address).to be_valid
    end
  end


  context "when the state is downcased from a valid entry" do
    let(:state) { 'md' }
    it "should be valid" do
      expect(billing_address).to be_valid
    end
  end
end

def billing_address_params
  {
    "street1" => "3733 Pointe Lane",
    "city" => "Hollywood",
    "state" =>  state,
    "postalCode" => "33020",
    "country" => country
  }
end