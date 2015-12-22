module NfgRestClient
  class BaseDonor < ObjectBase

    def initialize(attrs = {})
      super
    end

    validates :firstName, presence: true
    validates :lastName, presence: true
    validates :token, presence: true
    validates :email, presence: true

    private

  end
end