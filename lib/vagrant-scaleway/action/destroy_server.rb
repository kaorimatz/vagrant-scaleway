module VagrantPlugins
  module Scaleway
    module Action
      # This destroys the running server.
      class DestroyServer
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          server = env[:scaleway_compute].servers.get(env[:machine].id)

          # Destroy the server and remove the tracking ID
          env[:ui].info(I18n.t('vagrant_scaleway.destroying'))

          begin
            server.destroy
          rescue Fog::Scaleway::Compute::InvalidRequestError => e
            if e.message =~ /server should be stopped/
              server.terminate(false)
            else
              raise
            end
          end

          env[:machine].id = nil

          @app.call(env)
        end
      end
    end
  end
end
