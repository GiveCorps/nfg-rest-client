require 'rails/generators'

module NfgRestClient
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc 'Generates an initializer with suggested settings'

      source_root File.expand_path("../templates", __FILE__)

      def create_controller
        template "initializer.rb", initializer_file
      end

      private

      def initializer_file
        "config/initializers/nfg_rest_client.rb"
      end

    end
  end
end