module NfgRestClient
  class BillingAddress < ObjectBase

    def initialize(attrs = {})
      super
      self.country = country.upcase if country.present?
      self.state = state.upcase if state.present?
    end

    validates :street1, presence: true
    validates :city, presence: true
    validates :state do |object, field_name, field|
      if object.country == 'US' && object.state.nil?
        object._errors[field_name] << "must be present"
      elsif object.country == 'US' && !NfgRestClient::CountryState::STATE_CODES.include?(object.state)
        object._errors[field_name] << "#{object.state} is not a valid ansi 2 character code"
      elsif object.country != 'US' && NfgRestClient::CountryState::STATE_CODES.include?(object.state)
        object._errors[field_name] << "#{object.state} is valid US ansi 2 character code but the country is not set to US"
      end
    end
    validates :postalCode, presence: true
    validates :country, presence: true, inclusion: { in: NfgRestClient::CountryState::COUNTRY_CODES }
  end
end