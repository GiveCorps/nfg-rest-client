require "spec_helper"

shared_examples_for "a donation object" do

  context "when passing in a hash of attributes" do
    
  end

  it "should be valid if all of the keys are present and have appropriate values" do
    expect(donation).to be_valid
  end

  context 'when donationLineItems is not an array' do
    it "should not be valid" do
      
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

end

def donation_attributes(items_to_be_merged = {}, style = 'underscore')
  (style == 'underscore' ? valid_attributes : valid_attributes.inject({}) { |memo, (k, v)| memo[k.camelcase(:lower)] = v; memo }).merge(items_to_be_merged)
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
        }
    ],
    "total_amount" => 100,
    "tip_amount" => 0.0,
    "partner_transaction_id" => "__unique_transaction_id__",
    "payment" => { "source" => "CardOnFile"}
  }
end