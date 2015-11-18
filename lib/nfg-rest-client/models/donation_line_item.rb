module NfgRestClient
  class DonationLineItem < Base


    def initialize(attrs={})
      # convert all keys to camelcase with leading lowercase character
      attrs.deep_transform_keys!{ |key| key.to_s.camelcase(:lower) }
      super
    end

    validates :organizationId, presence: true

    private

  end
end