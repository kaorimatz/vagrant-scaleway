# frozen_string_literal: true

require 'vagrant/util/retryable'
require 'vagrant-scaleway/util/timer'

module VagrantPlugins
  module Scaleway
    module Action
      # This creates the configured server.
      class CreateServer
        include Vagrant::Util::Retryable

        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_scaleway::action::create_server')
        end

        def call(env)
          # Initialize metrics if they haven't been
          env[:metrics] ||= {}

          config = env[:machine].provider_config

          bootscript      = config.bootscript
          commercial_type = config.commercial_type
          image           = config.image
          name            = config.name
          security_group  = config.security_group
          tags            = config.tags
          volumes         = config.volumes.map.with_index(1).to_h.invert

          env[:ui].info(I18n.t('vagrant_scaleway.creating_server'))
          env[:ui].info(" -- Bootscript: #{bootscript}") if bootscript
          env[:ui].info(" -- Commercial Type: #{commercial_type}")
          env[:ui].info(" -- Image: #{image}")
          env[:ui].info(" -- Name: #{name}")
          env[:ui].info(" -- Security Group: #{security_group}") if security_group
          env[:ui].info(" -- Tags: #{tags}") unless tags.empty?
          env[:ui].info(" -- Volumes: #{volumes}") unless volumes.empty?

          options = {
            name: name,
            image: image,
            volumes: volumes,
            commercial_type: commercial_type,
            tags: tags
          }

          options[:bootscript] = bootscript if bootscript
          options[:security_group] = security_group if security_group

          begin
            server = env[:scaleway_compute].servers.create(options)
          rescue Fog::Scaleway::Compute::Error => e
            raise Errors::FogError, message: e.message
          rescue Excon::Errors::HTTPStatusError => e
            raise Errors::InternalFogError,
                  error: e.message,
                  response: e.response.body
          end

          @logger.info("Machine '#{name}' created.")

          # Immediately save the ID since it is created at this point.
          env[:machine].id = server.id

          # destroy the server if we were interrupted
          destroy(env) if env[:interrupted]

          @app.call(env)
        end

        def recover(env)
          return if env['vagrant.error'].is_a?(Vagrant::Errors::VagrantError)

          destroy(env) if env[:machine].provider.state.id != :not_created
        end

        def destroy(env)
          destroy_env = env.dup
          destroy_env.delete(:interrupted)
          destroy_env[:config_validate] = false
          destroy_env[:force_confirm_destroy] = true
          env[:action_runner].run(Action.action_destroy, destroy_env)
        end
      end
    end
  end
end
