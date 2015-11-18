require "spec_helper"

describe NfgRestClient::DonationLineItem do
  let(:donation_line_item) { NfgRestClient::DonationLineItem.new(attributes) }
  let(:attributes) { donation_line_item_attributes }

  it { validates_presence_of donation_line_item, :organizationId}
  it { validates_presence_of donation_line_item, :organizationIdType}
  it { validates_presence_of donation_line_item, :donorPrivacy}
  it { validates_presence_of donation_line_item, :amount}
  it { validates_presence_of donation_line_item, :feeAddOrDeduct}
  it { validates_presence_of donation_line_item, :transactionType}
  it { validates_presence_of donation_line_item, :recurrence}
  
end

def donation_line_item_attributes

  {
    "organizationId": "590624430",
    "organizationIdType": "Ein",
    "designation": "Project A",
    "dedication": "In honor of grandma",
    "donorPrivacy": "ProvideAll",
    "amount": "12.00",
    "feeAddOrDeduct": "Deduct",
    "transactionType": "Donation",
    "recurrence": "NotRecurring"
  }

  
end