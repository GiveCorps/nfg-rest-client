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
  end
end