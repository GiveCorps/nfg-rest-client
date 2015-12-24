module NfgRestClient
  class CardOnFilePayment < ObjectBase
    def initialize(attrs = {})
      super
      self.donor = instantiate_base_donor(donor)
    end

    validates :source, presence: true, inclusion: { in: %w{CardOnFile} }
    validates :donor, presence: true
    validates :cardOnFileId, presence: true

  end
end