module NfgRestClientStubs
  def stub_successful_credit_card_donation
    stub_successful_create_action(path: "/service/rest/donation", body: NfgRestClientStubs::RequestResponses.donation_success.to_json)
  end

  def stub_unsuccessful_credit_card_donation
    stub_successful_create_action(path: "/service/rest/donation", body: NfgRestClientStubs::RequestResponses.donation_failure.to_json)
  end

  def stub_successful_card_on_file_donation
    stub_successful_create_action(path: "/service/rest/donation", body: NfgRestClientStubs::RequestResponses.donation_success.to_json)
  end

  def stub_successful_card_on_file
    stub_successful_create_action(path: "/service/rest/cardOnFile", body: NfgRestClientStubs::RequestResponses.card_on_file_success.to_json)
  end

  def stub_unsuccessful_card_on_file
    stub_successful_create_action(path: "/service/rest/cardOnFile", body: NfgRestClientStubs::RequestResponses.card_on_file_failure.to_json)
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
    def self.donation_success(options = {})
      {
        "status" => "Success",
        "message" => "",
        "errorDetails" => [],
        "callDuration" => 7.7473,
        "chargeId" => 3584971,
        "cardOnFileId" => 0
      }.merge(options)
    end

    def self.donation_failure(options = {})
      {
        "status" => "ValidationFailed",
        "message" => "",
        "errorDetails" => [
          {
            "code" => "InvalidCreditCardNumber",
            "data" => "Credit card checksum validation failed"
          }
        ],
        "callDuration" => 0.05423,
        "chargeId" => 0,
        "cardOnFileId" => 0
      }.merge(options)
    end

    def self.card_on_file_success(options ={})
      {
        "status" => "Success",
        "message" => "",
        "errorDetails" => [],
        "callDuration" => 1.05423,
        "donorToken" => "802f365c-ed3d-4c80-8700-374aee6ac62c",
        "cardOnFileId" => 13338
      }
    end

    def self.card_on_file_failure(options = {})
      {
        "status" => "ChargeFailed",
        "message" => "",
        "errorDetails" => [],
        "callDuration" => 1.05423,
        "donorToken" => "802f365c-ed3d-4c80-8700-374aee6ac62c",
        "cardOnFileId" => 0
      }
    end
  end
end