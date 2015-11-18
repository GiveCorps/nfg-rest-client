module NfgRestClient
  class DonationLineItem < Flexirest::Base


    def initialize(attrs={})
      # convert all keys to camelcase with leading lowercase character
      attrs.deep_transform_keys!{ |key| key.to_s.camelcase(:lower) }
      super
    end

    validates :organizationId, presence: true
    validates :organizationIdType, presence: true
    validates :donorPrivacy, presence: true
    validates :amount, presence: true
    validates :feeAddOrDeduct, presence: true
    validates :transactionType, presence: true
    validates :recurrence, presence: true

    private

  end
end