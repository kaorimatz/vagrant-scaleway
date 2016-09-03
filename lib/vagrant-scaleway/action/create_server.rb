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

          env[:ui].info(I18n.t('vagrant_scaleway.creating_server'))
          env[:ui].info(" -- Bootscript: #{bootscript}") if bootscript
          env[:ui].info(" -- Commercial Type: #{commercial_type}")
          env[:ui].info(" -- Image: #{image}")
          env[:ui].info(" -- Name: #{name}")
          env[:ui].info(" -- Security Group: #{security_group}") if security_group
          env[:ui].info(" -- Tags: #{tags}") unless tags.empty?

          options = {
            name:            name,
            image:           image,
            commercial_type: commercial_type,
            tags:            tags
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

          begin
            @app.call(env)
          rescue Exception => e
            # Delete the server
            terminate(env)

            raise e
          end

          # Terminate the server if we were interrupted
          terminate(env) if env[:interrupted]
        end
      end
    end
  end
end
