require "spec_helper"

describe NfgRestClient::BillingAddress do
  include NfgRestClient::SpecAttributes
  let(:billing_address) { NfgRestClient::BillingAddress.new(attributes) }
  let(:attributes) { donation_billing_address_attributes }
  # let(:state) { "FL" }
  # let(:country) { "US" }

  it { validate_presence_of billing_address, :street1 }
  it { validate_presence_of billing_address, :city }
  it { validate_presence_of billing_address, :postalCode }
  it { validate_presence_of billing_address, :country }
  it { validate_inclusion_of billing_address, :country, { in: NfgRestClient::CountryState::COUNTRY_CODES } }

  context "when the country is US" do

    it { validate_presence_of billing_address, :state }

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

    context "and the state is nil" do
      let(:state) { nil }
      it "should be valid" do
        expect(billing_address).to be_valid
      end
    end

    context "and the state is in the list of ansi 2 character codes" do
      let(:state) { "FL" }
      it "should not be valid" do
        expect(billing_address).not_to be_valid
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