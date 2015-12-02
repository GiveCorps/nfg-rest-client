module NfgRestClient
  class CreditCardPayment < ObjectBase
    def initialize(attrs = {})
      super
      self.storeCardOnFile = false if storeCardOnFile.nil?
      self.donor = instantiate_donor(donor)
      self.creditCard = instantiate_credit_card(creditCard)
    end

    validates :source, presence: true, inclusion: { in: %w{CreditCard CardOnFile} }
    validates :donor, presence: true
    validates :creditCard, presence: true

    validates :donor do |object, field_name, donor|
      next if donor.nil?
      unless donor.valid?
        object._errors[field_name] << donor.full_error_messages
      end
    end

    validates :creditCard do |object, field_name, credit_card|
      next if credit_card.nil?
      unless credit_card.valid?
        object._errors[field_name] << credit_card.full_error_messages
      end
    end

    private

    def instantiate_donor(donor)
      return donor unless donor.present? && donor.is_a?(Hash)
      NfgRestClient::CreditCardDonor.new(donor)
    end

    def instantiate_credit_card(credit_card)
      return credit_card unless credit_card.present? and credit_card.is_a?(Hash)
      NfgRestClient::CreditCard.new(credit_card)
    end
  end
end