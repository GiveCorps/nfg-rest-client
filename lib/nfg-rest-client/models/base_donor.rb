module NfgRestClient
  class BaseDonor < ObjectBase

    def initialize(attrs = {})
      super
      self.ip = "127.0.0.1" unless ip.present?
    end

    validates :firstName, presence: true
    validates :lastName, presence: true
    validates :token, presence: true
    validates :email, presence: true

    private

  end
end