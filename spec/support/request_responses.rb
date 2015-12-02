module NfgRestClientStubs
  def stub_successful_credit_card_donation
    stub_successful_create_action(path: "/service/rest/donation", body: NfgRestClientStubs::RequestResponses.credit_card_donation_success.to_json)
  end

  def stub_successful_create_action(options)
    stub_create_action(options.merge(status: 200))
  end

  def stub_create_action(options)
    stub_action(options.merge(action: :post))
  end

  def stub_action(options)
    # stub_request comes from webmock
    stub_request(:post, "https://api-sandbox.networkforgood.org#{options[:path]}").to_return(:status => options[:status], :body => options[:body], :headers => {})
  end

  class RequestResponses
    def self.credit_card_donation_success(options = {})
      {
        "status" => "Success",
        "message" => "",
        "errorDetails" => [],
        "callDuration" => 7.7473,
        "chargeId" => 3584971,
        "cardOnFileId" => 0
      }.merge(options)
    end
  end
end