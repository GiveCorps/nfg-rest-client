module NfgRestClient
  module Configuration
    module ClassMethods
      @@sandbox_nfg_base_url = "https://:domain_name/:request_type/rest"
      @@production_nfg_base_url = "https://api.networkforgood.org/:request_type/rest"
      @@use_sandbox = true
      @@sandbox_domain_name = nil
      @@userid = nil
      @@password = nil
      @@source = nil
      @@scope = nil
      @@token = nil
      @@campaign = "DNTAPI"


      def set_production_base_urls
        @@use_sandbox = false
        # the base_url needs to be set on each object because it is a class
        # variable that is not inheritable and is different depending on the
        # action being taken. When the NfgRestClient classes are loaded, the base_url
        # is set to the sandbox (since often the class is loaded before initialization
        # files are run). So we need to override that here. This method should
        # be called in an initializer by the application only in a production
        # environment
        NfgRestClient::Donation.base_url NfgRestClient::Base.base_nfg_service_url
        NfgRestClient::CardOnFile.base_url NfgRestClient::Base.base_nfg_service_url
        NfgRestClient::AccessToken.base_url NfgRestClient::Base.base_nfg_access_url
      end

      def base_nfg_url
        if @@use_sandbox
          @@sandbox_nfg_base_url.gsub ":domain_name", sandbox_domain_name
        else
          @@production_nfg_base_url
        end
      end

      def base_nfg_access_url
        base_nfg_url.gsub ":request_type", "access"
      end

      def base_nfg_service_url
        base_nfg_url.gsub ":request_type", "service"
      end

      def userid(value = nil)
        if value.nil?
          if @userid.nil?
            @@userid
          else
            @userid
          end
        else
          @userid = value
        end
      end

      def userid=(value)
        NfgRestClient::Logger.info "\033[1;4;32m#{name}\033[0m UserId set to be #{value}"
        @@userid = value
      end

      def password(value = nil)
        if value.nil?
          if @password.nil?
            @@password
          else
            @password
          end
        else
          value = CGI::escape(value) if value.present? && !value.include?("%")
          @password = value
        end
      end

      def password=(value)
        NfgRestClient::Logger.info "\033[1;4;32m#{name}\033[0m Password set..."
        value = CGI::escape(value) if value.present? && !value.include?("%")
        @@password = value
      end

      def source(value = nil)
        if value.nil?
          if @source.nil?
            @@source
          else
            @source
          end
        else
          value = CGI::escape(value) if value.present? && !value.include?("%")
          @source = value
        end
      end

      def source=(value)
        NfgRestClient::Logger.info "\033[1;4;32m#{name}\033[0m source set..."
        value = CGI::escape(value) if value.present? && !value.include?("%")
        @@source = value
      end

      def campaign(value = nil)
        if value.nil?
          if @campaign.nil?
            @@campaign
          else
            @campaign
          end
        else
          value = CGI::escape(value) if value.present? && !value.include?("%")
          @campaign = value
        end
      end

      def campaign=(value)
        NfgRestClient::Logger.info "\033[1;4;32m#{name}\033[0m campaign set..."
        value = CGI::escape(value) if value.present? && !value.include?("%")
        @@campaign = value
      end

      def token(value = nil)
        if value.nil?
          if @token.nil?
            @@token
          else
            @token
          end
        else
          value = CGI::escape(value) if value.present? && !value.include?("%")
          @token = value
        end
      end

      def token=(value)
        NfgRestClient::Logger.info "\033[1;4;32m#{name}\033[0m token set..."
        value = CGI::escape(value) if value.present? && !value.include?("%")
        @@token = value
      end

      def sandbox_domain_name=(value)
        NfgRestClient::Logger.info "\033[1;4;32m#{name}\033[0m sandbox domain name set..."
        value = CGI::escape(value) if value.present? && !value.include?("%")
        @@sandbox_domain_name = value
      end

      def sandbox_domain_name
        @@sandbox_domain_name || 'api-sandbox.networkforgood.org'
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end