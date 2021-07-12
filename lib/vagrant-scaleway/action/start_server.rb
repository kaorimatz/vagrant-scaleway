# frozen_string_literal: true

require 'vagrant/util/retryable'
require 'vagrant-scaleway/util/timer'

module VagrantPlugins
  module Scaleway
    module Action
      # This starts a stopped server.
      class StartServer
        include Vagrant::Util::Retryable

        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_scaleway::action::start_server')
        end

        def call(env)
          # Initialize metrics if they haven't been
          env[:metrics] ||= {}

          config = env[:machine].provider_config

          server = env[:scaleway_compute].servers.get(env[:machine].id)

          env[:ui].info(I18n.t('vagrant_scaleway.starting'))

          begin
            server.poweron
          rescue Fog::Scaleway::Compute::Error => e
            raise Errors::FogError, message: e.message
          end

          # Wait for the server to be ready first
          env[:metrics]['server_ready_time'] = Util::Timer.time do
            tries = config.server_ready_timeout / 2

            env[:ui].info(I18n.t('vagrant_scaleway.waiting_for_ready'))
            begin
              retryable(on: Fog::Errors::TimeoutError, tries: tries) do
                # If we're interrupted don't worry about waiting
                next if env[:interrupted]

                # Wait for the server to be ready
                server.wait_for(2, config.server_check_interval) { ready? }
              end
            rescue Fog::Errors::TimeoutError
              # Notify the user
              raise Errors::ServerReadyTimeout,
                    timeout: config.server_ready_timeout
            end
          end

          @logger.info("Time to server ready: #{env[:metrics]['server_ready_time']}")

          unless env[:interrupted]
            env[:metrics]['server_ssh_time'] = Util::Timer.time do
              # Wait for SSH to be ready.
              env[:ui].info(I18n.t('vagrant_scaleway.waiting_for_ssh'))
              network_ready_retries = 0
              network_ready_retries_max = 10
              loop do
                # If we're interrupted then just back out
                break if env[:interrupted]

                # When a server comes up, it's networking may not be ready by
                # the time we connect.
                begin
                  break if env[:machine].communicate.ready?
                rescue StandardError
                  if network_ready_retries < network_ready_retries_max
                    network_ready_retries += 1
                    @logger.warn(I18n.t('vagrant_scaleway.waiting_for_ssh, retrying'))
                  else
                    raise
                  end
                end
                sleep 2
              end
            end

            @logger.info("Time for SSH ready: #{env[:metrics]['server_ssh_time']}")

            # Ready and booted!
            env[:ui].info(I18n.t('vagrant_scaleway.ready'))
          end

          @app.call(env)
        end
      end
    end
  end
end
