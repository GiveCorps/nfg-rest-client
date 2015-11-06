module NfgRestClient
  class AccessToken < Base

    def initialize(args = {})
      super
      self.password = self.class.password
      self.scope = "donation donation-reporting"
    end
    post :create, "/token"

  end
end