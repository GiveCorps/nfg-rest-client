module NfgRestClient
  class BaseTransaction < Base
    before_request :add_authentication_details
    self.base_url base_nfg_service_url # pass the url so it is set as a variable on this instance of the class, not on the root class

    private

    def add_authentication_details(name, request)
      request.headers["Authorization"] = "Bearer #{self.class.token}"
    end
  end
end