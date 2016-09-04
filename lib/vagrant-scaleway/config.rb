module VagrantPlugins
  module Scaleway
    class Config < Vagrant.plugin('2', :config)
      # The bootscript ID. If nil, the default bootscript for the image will be
      # used.
      #
      # @return [String]
      attr_accessor :bootscript

      # The type of the server to launch, such as 'C1'. Defaults to 'C2S'.
      #
      # @return [String]
      attr_accessor :commercial_type

      # The image ID.
      #
      # @return [String]
      attr_accessor :image

      # The name of the server.
      #
      # @return [String]
      attr_accessor :name

      # The organization ID. It can also be configured with SCW_ORGANIZATION
      # environment variable.
      #
      # @return [String]
      attr_accessor :organization

      # The security group to associate with the server. If nil, organization's
      # default security group will be used.
      #
      # @return [String]
      attr_accessor :security_group

      # The interval to wait for checking a server's state. Defaults to 2
      # seconds.
      #
      # @return [Fixnum]
      attr_accessor :server_check_interval

      # The timeout to wait for a server to become ready. Defaults to 120
      # seconds.
      #
      # @return [Fixnum]
      attr_accessor :server_ready_timeout

      # Specifies which address to connect to with ssh.
      # Must be one of:
      #  - :public_ip_address
      #  - :public_dns_name
      #  - :private_ip_address
      #  - :private_dns_name
      # This attribute also accepts an array of symbols.
      #
      # @return [Symbol]
      attr_accessor :ssh_host_attribute

      # Tags to apply to the server.
      #
      # @return [Array]
      attr_accessor :tags

      # The API token to access Scaleway. It can also be configured with
      # SCW_TOKEN environment variable.
      #
      # @return [String]
      attr_accessor :token

      def initialize
        @bootscript            = UNSET_VALUE
        @commercial_type       = UNSET_VALUE
        @image                 = UNSET_VALUE
        @name                  = UNSET_VALUE
        @organization          = UNSET_VALUE
        @server_check_interval = UNSET_VALUE
        @server_ready_timeout  = UNSET_VALUE
        @security_group        = UNSET_VALUE
        @ssh_host_attribute    = UNSET_VALUE
        @tags                  = []
        @token                 = UNSET_VALUE
      end

      def finalize!
        @bootscript      = nil if @bootscript == UNSET_VALUE
        @commercial_type = 'C2S' if @commercial_type == UNSET_VALUE
        @image           = '75c28f52-6c64-40fc-bb31-f53ca9d02de9' if @image == UNSET_VALUE

        if @name == UNSET_VALUE
          require 'securerandom'
          @name = "scw-#{SecureRandom.hex(3)}"
        end

        @organization          = ENV['SCW_ORGANIZATION'] if @organization == UNSET_VALUE
        @server_check_interval = 2 if @server_check_interval == UNSET_VALUE
        @server_ready_timeout  = 120 if @server_ready_timeout == UNSET_VALUE
        @security_group        = nil if @security_group == UNSET_VALUE
        @ssh_host_attribute    = nil if @ssh_host_attribute == UNSET_VALUE
        @token                 = ENV['SCW_TOKEN'] if @token == UNSET_VALUE
      end
    end

    def validate(_machine)
      errors = _detected_errors

      errors << I18n.t('vagrant_scaleway.config.organization_required') if @organization.nil?
      errors << I18n.t('vagrant_scaleway.config.token_required') if @token.nil?

      { 'Scaleway Provider' => errors }
    end
  end
end
