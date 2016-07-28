module NfgRestClient
  class DonationLineItem < Flexirest::Base


    def initialize(attrs={})
      attrs = default_values.merge(attrs)
      super
    end

    validates :organizationId, presence: true
    validates :organizationIdType, presence: true, inclusion: { in: ["Ein", "NcesSchoolId", "V4AccountId", "V4OrganizationId"] }
    validates :donorPrivacy, presence: true, inclusion: { in: %w{ProvideAll ProvideNameAndEmailOnly Anonymous} }
    validates :amount, presence: true, numericality: { minimum: 1 }
    validates :feeAddOrDeduct, presence: true, inclusion: { in: %w{Add Deduct} }
    validates :transactionType, presence: true, inclusion: { in: %w{Donation Ticket StoredValuePurchase} }
    validates :recurrence, presence: true, inclusion: { in: %w{NotRecurring Monthly Quarterly Annually} }
    validates :designation, existence: true
    validates :dedication, existence: true

    private

    def default_values
      {
       "donorPrivacy" => "ProvideAll",
       "dedication" => "",
       "recurrence" => "NotRecurring"
      }
    end

  end
end