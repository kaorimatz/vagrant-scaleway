# frozen_string_literal: true

module VagrantPlugins
  module Scaleway
    module Action
      class WarnNetworks
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          env[:ui].warn(I18n.t('vagrant_scaleway.warn_networks')) if env[:machine].config.vm.networks.length > 1

          @app.call(env)
        end
      end
    end
  end
end
