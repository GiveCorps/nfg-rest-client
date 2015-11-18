require "spec_helper"

describe NfgRestClient::DonationLineItem do
  let(:donation_line_item) { NfgRestClient::DonationLineItem.new(attributes) }
  let(:attributes) { donation_line_item_attributes }

  it { validate_presence_of donation_line_item, :organizationId}
  it { validate_presence_of donation_line_item, :organizationIdType}
  it { validate_presence_of donation_line_item, :donorPrivacy}
  it { validate_presence_of donation_line_item, :amount}
  it { validate_presence_of donation_line_item, :feeAddOrDeduct}
  it { validate_presence_of donation_line_item, :transactionType}
  it { validate_presence_of donation_line_item, :recurrence}

end

def donation_line_item_attributes

  {
    "organizationId" => "590624430",
    "organizationIdType" => "Ein",
    "designation" => "Project A",
    "dedication" => "In honor of grandma",
    "donorPrivacy" => "ProvideAll",
    "amount" => "12.00",
    "feeAddOrDeduct" => "Deduct",
    "transactionType" => "Donation",
    "recurrence" => "NotRecurring"
  }

  
end
