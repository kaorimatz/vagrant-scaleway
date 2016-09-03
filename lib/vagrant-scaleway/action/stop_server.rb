module VagrantPlugins
  module Scaleway
    module Action
      # This stops the running server.
      class StopServer
        def initialize(app, _env)
          @app    = app
        end

        def call(env)
          server = env[:scaleway_compute].servers.get(env[:machine].id)

          if env[:machine].state.id == :stopped
            env[:ui].info(I18n.t('vagrant_scaleway.already_status', status: env[:machine].state.id))
          else
            env[:ui].info(I18n.t('vagrant_scaleway.stopping'))
            server.poweroff(false)
          end

          @app.call(env)
        end
      end
    end
  end
end
