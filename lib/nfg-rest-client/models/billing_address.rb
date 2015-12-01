module NfgRestClient
  class BillingAddress < ObjectBase

    def initialize(attrs = {})
      super
      self.country = country.upcase if country.present?
      self.state = state.upcase if state.present?
    end

    validates :street1, presence: true
    validates :city, presence: true
    validates :state, presence: true do |object, field_name, state|
      next unless object.country == 'US' && state.present?
      unless NfgRestClient::CountryState::STATE_CODES.include?(state)
        object._errors[field_name] << "#{state} is not a valid ansi 2 character code"
      end
    end
    validates :postalCode, presence: true
    validates :country, presence: true, inclusion: { in: NfgRestClient::CountryState::COUNTRY_CODES }
  end
end