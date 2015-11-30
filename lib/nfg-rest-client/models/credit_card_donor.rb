module NfgRestClient
  class CreditCardDonor < ObjectBase

    def initialize(attrs = {})
      super
      self.billingAddress = instantiate_billing_address(billingAddress) if billingAddress.present?
    end

    validates :ip, presence: true
    validates :firstName, presence: true
    validates :lastName, presence: true
    validates :billingAddress, presence: true
    validates :token, presence: true
    validates :email, presence: true

    validates :billingAddress do |object, field_name, billing_address|
      next if billing_address.nil?
      unless billing_address.valid?
        object._errors[field_name] << billing_address.full_error_messages
      end
    end

    private

    def instantiate_billing_address(billing_address)
      return billing_address unless billing_address.present? && billing_address.is_a?(Hash)
      NfgRestClient::BillingAddress.new(billing_address)
    end
  end
end