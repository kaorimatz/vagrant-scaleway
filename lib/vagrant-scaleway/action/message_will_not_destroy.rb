module VagrantPlugins
  module Scaleway
    module Action
      class MessageWillNotDestroy
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t('vagrant_scaleway.will_not_destroy', name: env[:machine].name))
          @app.call(env)
        end
      end
    end
  end
end
