require "spec_helper"

shared_examples_for "a donation object" do

  context "when passing in a hash of attributes" do

  end

  it "should be valid if all of the keys are present and have appropriate values" do
    donation.valid?
    expect(donation).to be_valid
  end

  context 'when donationLineItems is not an array' do
    let(:changes_to_attributes) { { "donation_line_items" => "bad_data"} }
    it "should not be valid" do
      expect(donation.valid?).to be_falsy
      expect(donation.errors[:donationLineItems]).to be_present
    end
  end

  context 'when donationLineItems is an empty array' do
    let(:changes_to_attributes) { { "donation_line_items" => []} }
    it "should not be valid" do
      expect(donation.valid?).to be_falsy
      expect(donation.errors[:donationLineItems]).to be_present
    end
  end

  context 'when donationLineItems contain an invalid value' do
    let(:changes_to_attributes) { { "donation_line_items" => [{  "organizationId" => "590624430",
          "organizationIdType" => "Ein",
          "designation" => "Project A",
          "dedication" => "In honor of grandma",
          "donorPrivacy" => "NOT A VALID DonorPrivacy Value",
          "amount" => "12.00",
          "feeAddOrDeduct" => "Deduct",
          "transactionType" => "Donation",
          "recurrence" => "NotRecurring"
        }]} }

    it "should not be valid" do
      expect(donation.valid?).to be_falsy
      expect(donation.errors[:donationLineItems]).to be_present
    end
  end
end

describe NfgRestClient::Donation do
  let(:donation) { NfgRestClient::Donation.new(donation_attributes(changes_to_attributes,  "underscore")) }
  let(:changes_to_attributes) { {} }
  subject { donation }

  it { validate_presence_of donation, :donationLineItems }
  it { validate_presence_of donation, :totalAmount }
  it { validate_presence_of donation, :tipAmount }
  it { validate_presence_of donation, :partnerTransactionId }
  it { validate_presence_of donation, :payment }

  context "when provided an hash with underscore separated keys" do
  let(:donation) { NfgRestClient::Donation.new(attributes) }
  let(:attributes) { donation_attributes(changes_to_attributes,  "underscore") }

    it_should_behave_like "a donation object"
  end

  context "when provided an hash with camelcase and leading lowercase keys" do
    let(:donation) { NfgRestClient::Donation.new(attributes) }
    let(:attributes) { donation_attributes(changes_to_attributes,  "camelcase") }

    it_should_behave_like "a donation object"
  end

  describe "sub model instantiation" do
    describe "donation line items" do
      it "should instantiate a donation_line_item object for each item in the donation_line_items array " do
        dli = NfgRestClient::DonationLineItem.new
        dli.expects(:valid?).twice.returns(true)
        NfgRestClient::DonationLineItem.expects(:new).times(valid_attributes["donation_line_items"].count).returns(dli)
        donation.valid?
      end
    end

    describe "CreditCardPayment" do
      context "when the payment method is a credit card" do
        it "should instantiate a credit card payment record" do
          cc = NfgRestClient::CreditCardPayment.new
          cc.expects(:valid?).returns(true)
          NfgRestClient::CreditCardPayment.expects(:new).once.returns(cc)
          donation.valid?
        end
      end

      context "when the payment method is a card on file" do
        let(:changes_to_attributes) { { "payment" => card_on_file_payment } }

        it "should instantiate a card on file payment record" do
          cc = NfgRestClient::CardOnFilePayment.new
          cc.expects(:valid?).returns(true)
          NfgRestClient::CardOnFilePayment.expects(:new).once.returns(cc)
          donation.valid?
        end
      end
    end
  end

end

def donation_attributes(items_to_be_merged = {}, style = 'underscore')
  (style == 'underscore' ? valid_attributes : valid_attributes.inject({}) { |memo, (k, v)| memo[k.camelcase(:lower)] = v; memo })
  .merge('underscore' ? items_to_be_merged : items_to_be_merged.inject({}) { |memo, (k, v)| memo[k.camelcase(:lower)] = v; memo })
end

def valid_attributes
  hsh = {
    "donation_line_items" => [
        {  "organizationId" => "590624430",
          "organizationIdType" => "Ein",
          "designation" => "Project A",
          "dedication" => "In honor of grandma",
          "donorPrivacy" => "ProvideAll",
          "amount" => "12.00",
          "feeAddOrDeduct" => "Deduct",
          "transactionType" => "Donation",
          "recurrence" => "NotRecurring"
        },

        {  "organizationId" => "590624430",
          "organizationIdType" => "Ein",
          "designation" => "Project A",
          "amount" => "12.00",
          "feeAddOrDeduct" => "Deduct",
          "transactionType" => "Donation",
        }
    ],
    "total_amount" => 100,
    "tip_amount" => 0.0,
    "partner_transaction_id" => "__unique_transaction_id__",
    "payment" => { "source" => "CreditCard",
                  "donor" => {
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
                   },
                   "creditCard" => {
                     "nameOnCard" => "Francis G. Carter",
                     "type" => "Visa",
                     "number" => "4111111111111111",
                     "expiration" => {
                       "month" => 11,
                       "year" => 2019
                     },
                     "securityCode" => "123"
                   }
    }
  }
end

def card_on_file_payment
  {
    "source" => "CardOnFile",
    "cardOnFileId" => 1096597,
    "donor" => {
        "ip" => "50.121.129.54",
        "token" => "802f365c-ed3d-4c80-8700-374aee6ac62c"
    }
  }
end