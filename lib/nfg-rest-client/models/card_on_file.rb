module NfgRestClient
  class CardOnFile < BaseTransaction
    self.base_url base_nfg_service_url

    def initialize(attrs = {})
      super
      self.donor = instantiate_donor(donor)
      self.credit_card = instantiate_credit_card(creditCard)
    end

    validates :donor, presence: true
    validates :credit_card, presence: true

    post :create, '/cardOnFile'

  end
end