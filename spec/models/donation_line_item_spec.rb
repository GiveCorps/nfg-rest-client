require "spec_helper"

describe NfgRestClient::DonationLineItem do
  let(:donation_line_item) { NfgRestClient::DonationLineItem.new(attributes) }
  let(:attributes) { donation_line_item_attributes }

  it { validate_presence_of donation_line_item, :organizationId }

  it { validate_presence_of donation_line_item, :organizationIdType }
  it { validate_inclusion_of donation_line_item, :organizationIdType, in: ["Ein", "NcesSchoolId", "V4AccountId", "V4OrganizationId"] }

  it { validate_presence_of donation_line_item, :donorPrivacy }
  it { validate_inclusion_of donation_line_item, :donorPrivacy, in: %w{ProvideAll ProvideNameAndEmailOnly Anonymous} }

  it { validate_presence_of donation_line_item, :feeAddOrDeduct }
  it { validate_inclusion_of donation_line_item, :feeAddOrDeduct, in: %w{Add Deduct} }

  it { validate_presence_of donation_line_item, :transactionType }
  it { validate_inclusion_of donation_line_item, :transactionType, in: %w{Donation Ticket StoredValuePurchase} }

  it { validate_presence_of donation_line_item, :recurrence }
  it { validate_inclusion_of donation_line_item, :recurrence, in: %w{NotRecurring Monthly Quarterly Annually} }

  it { validate_presence_of donation_line_item, :amount }
  it { validate_numericality_of donation_line_item, :amount, minimum: 1 }

  context "when no dedication is provided" do
    let(:attributes) { donation_line_item_attributes.delete_if { |k, v| k == "dedication" } }

    it "should set the dedication value to an empty string" do
      expect(donation_line_item.dedication).to eq("")
    end
  end


end

def donation_line_item_attributes

  {
    "organizationId" => "590624430",
    "organizationIdType" => "Ein",
    "dedication" => "In honor of grandma",
    "designation" => 'Gym',
    "donorPrivacy" => "ProvideAll",
    "recurrence" => "NotRecurring",
    "amount" => "12.00",
    "feeAddOrDeduct" => "Deduct",
    "transactionType" => "Donation",
    "recurrence" => "NotRecurring"
  }


end
