module NfgRestClient
  class DonationLineItem < Flexirest::Base


    def initialize(attrs={})
      # convert all keys to camelcase with leading lowercase character
      attrs = default_values.merge(attrs)
      attrs.deep_transform_keys!{ |key| key.to_s.camelcase(:lower) }
      super
    end

    validates :organizationId, presence: true
    validates :organizationIdType, presence: true
    validates :organizationIdType, inclusion: { in: ["Ein", "NcesSchoolId"] }

    validates :donorPrivacy, presence: true
    validates :donorPrivacy, inclusion: { in: %w{ProvideAll ProvideNameAndEmailOnly Anonymous} }

    validates :amount, presence: true
    validates :amount, numericality: { minimum: 1 }

    validates :feeAddOrDeduct, presence: true
    validates :feeAddOrDeduct, inclusion: { in: %w{Add Deduct} }

    validates :transactionType, presence: true
    validates :transactionType, inclusion: { in: %w{Donation Ticket StoredValuePurchase} }

    validates :recurrence, presence: true
    validates :recurrence, inclusion: { in: %w{NotRecurring Monthly Quarterly Annually} }

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