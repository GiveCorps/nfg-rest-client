module NfgRestClient
  class BaseTransaction < Base
    before_request :add_authentication_details

    def initialize(attrs={})
      super
      self.campaign = self.class.campaign
    end

    def successful?
      status == "Success"
    end

    def response_error_details
      errorDetails.map { |error| "#{error['code']}: #{error["data"]}"}.join()
    end

    def bearer_token= (token)
      @token = token
    end

    def bearer_token
      @token || self.class.token
    end

    private

    def add_authentication_details(name, request)
      request.headers["Authorization"] = "Bearer #{request.object.bearer_token}"
    end
  end
end