module NfgRestClient
  class BaseTransaction < Base
    before_request :add_authentication_details

    private

    def add_authentication_details
      request.headers["Autorization"] = "Bearer #{self.class.token}"
    end
  end
end