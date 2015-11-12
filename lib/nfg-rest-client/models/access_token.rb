module NfgRestClient
  class AccessToken < BaseAccess
    verbose!

    def initialize(attrs={})
      super
      self.password = self.class.password
      self.scope = "donation donation-reporting"
    end

    post :create, "/token"

    private

    def request_type
      'access'
    end
  end
end