module NfgRestClient
  module Configuration
    module ClassMethods
      @@sandbox_nfg_base_url = "https://api-sandbox.networkforgood.org/:request_type/rest"
      @@production_nfg_base_url = "https://api.networkforgood.org/:request_type/rest"
      @@use_sandbox = true
      @@userid = nil
      @@password = nil
      @@source = nil
      @@scope = nil
      @@campaign = "DNTAPI"

      def use_sandbox
        if @use_sandbox.nil?
          @@use_sandbox
        else
          @use_sandbox
        end
      end

      def use_sandbox=(value)
        @@use_sandbox = value
      end

      def base_nfg_url
        if use_sandbox
          @@sandbox_nfg_base_url
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

    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end