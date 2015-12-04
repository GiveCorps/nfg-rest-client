module NfgRestClient
  class ObjectBase < Flexirest::Base
    def initialize(attrs={})
      # convert all keys to camelcase with leading lowercase character
      attrs.deep_transform_keys!{ |key| key.to_s.camelcase(:lower) }
      super
    end

    private

    def instantiate_donation_line_items(donation_line_items)
      return unless donation_line_items.present? && donation_line_items.is_a?(Array)
      donation_line_items.map do |donation_line_item_hash|
        NfgRestClient::DonationLineItem.new(donation_line_item_hash)
      end
    end

    def instantiate_payment_method(payment_method)
      return payment_method unless payment_method.present? && payment_method.is_a?(Hash)
      "NfgRestClient::#{payment_method["source"]}Payment".constantize.new(payment_method)
    end

    def instantiate_donor(donor)
      return donor unless donor.present? && donor.is_a?(Hash)
      NfgRestClient::CreditCardDonor.new(donor)
    end

    def instantiate_credit_card(credit_card)
      return credit_card unless credit_card.present? && credit_card.is_a?(Hash)
      NfgRestClient::CreditCard.new(credit_card)
    end
  end
end