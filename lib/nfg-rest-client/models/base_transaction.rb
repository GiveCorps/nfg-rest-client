module NfgRestClient
  class BaseTransaction < Base
    before_request :add_authentication_details

    def initialize(attrs={})
      super
      self.campaign = self.class.campaign
    end

    private

    def add_authentication_details(name, request)
      request.headers["Authorization"] = "Bearer #{self.class.token}"
    end
  end
end