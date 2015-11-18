require "spec_helper"

shared_examples_for "a donation object" do
  NfgRestClient::Donation.required_attributes.each do |method_name|
    it "will raise an error unless the hash includes a non-nil value for #{method_name} or #{method_name.camelcase(:lower)} " do
      expect{ NfgRestClient::Donation.new(create_object(method_name, format)) }.to raise_error(NoMethodError)
    end
  end

  it "should be not raise an error if all of the keys are present and have values" do
    expect{ NfgRestClient::Donation.new(create_object(nil, format)) }.not_to raise_error
  end
end

describe NfgRestClient::Donation do
  let(:donation) { NfgRestClient::Donation.new }
  subject { donation }

  it { validate_presence_of donation, :donationLineItems }
  it { validate_presence_of donation, :total_amount }
  it { validate_presence_of donation, :tip_amount }
  it { validate_presence_of donation, :partner_transaction_id }
  it { validate_presence_of donation, :payment }


  describe "initilization" do

    context "when provided an hash with underscore separated keys" do
      let(:format) { "underscore" }

      # it_should_behave_like "a donation object"
    end

    context "when provided an hash with camelcase and leading lowercase keys" do
      let(:format) { "camelcase" }

      # it_should_behave_like "a donation object"
    end
  end

end

def create_object(method_that_is_missing = nil, style = 'underscore')
  hsh = method_that_is_missing.present? ? valid_attributes.delete_if { |k, v| k = method_that_is_missing } : valid_attributes
  style == 'underscore' ? hsh : hsh.inject({}) { |memo, (k, v)| memo[k.camelcase(:lower)] = v; memo }
end

def valid_attributes
  hsh = {
    "donation_line_items" => [{ "organizationId" => "541037615" }],
    "total_amount" => 100,
    "tip_amount" => 0.0,
    "partner_transaction_id" => "__unique_transaction_id__",
    "payment" => { "source" => "CardOnFile"}
  }
end

def validate_presence_of(obj, attribute)
  obj.valid?
  expect(obj.errors[attribute]).to include("must be present")
end