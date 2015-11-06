require 'rails/generators'

module NfgRestClient
  class InstallGenerator < Rails::Generators::Base
    desc 'Generates an inizializer with suggested settings'

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def create_controller
      template "initializer.rb", initializer
    end

    private

    def initializer
      "app/config/initializers/nfg_rest_client.rb"
    end

  end
end