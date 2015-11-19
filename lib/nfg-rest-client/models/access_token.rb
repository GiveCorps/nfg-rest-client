module NfgRestClient
  class AccessToken < Base
    verbose!
    self.base_url base_nfg_access_url

    def initialize(attrs={})
      super
      self.userid = self.class.userid
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