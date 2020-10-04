# frozen_string_literal: true

module VagrantPlugins
  module Scaleway
    module Action
      class MessageNotCreated
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t('vagrant_scaleway.not_created'))
          @app.call(env)
        end
      end
    end
  end
end
