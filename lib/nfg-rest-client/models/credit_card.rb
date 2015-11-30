module NfgRestClient
  class CreditCard < ObjectBase

    def initialize(attrs = {})
      super
      self.expiration = instantiate_expiration_date(expiration) if expiration.present?
    end

    validates :nameOnCard, presence: true
    validates :type, presence: true, inclusion: { in: %w{Visa Mastercard Amex} }
    validates :number, presence: true
    validates :expiration, presence: true
    validates :securityCode, presence: true

    validates :expiration do |object, field_name, expiration|
      next unless expiration.present?
      if !expiration.valid?
        object._errors[field_name] << expiration.full_error_messages
      end
    end

    private

    def instantiate_expiration_date(expiration)
      return expiration unless expiration.present? && expiration.is_a?(Hash)
      NfgRestClient::ExpirationDate.new(expiration)
    end

  end
end