# frozen_string_literal: true

require 'fog/scaleway'

module VagrantPlugins
  module Scaleway
    module Action
      # This action connects to Scaleway, verifies credentials work, and
      # puts the Scaleway connection object into the `:scaleway_compute` key
      # in the environment.
      class ConnectScaleway
        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_scaleway::action::connect_scaleway')
        end

        def call(env)
          # Get the configs
          provider_config = env[:machine].provider_config

          # Build the fog config
          fog_config = {
            provider: :scaleway,
            scaleway_organization: provider_config.organization,
            scaleway_token: provider_config.token,
            scaleway_region: provider_config.region
          }

          @logger.info('Connecting to Scaleway...')
          env[:scaleway_compute] = Fog::Compute.new(fog_config)

          @app.call(env)
        end
      end
    end
  end
end
