# frozen_string_literal: true

module VagrantPlugins
  module Scaleway
    module Action
      class ListSecurityGroups
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          compute = env[:scaleway_compute]

          env[:ui].info(format('%-37s %s', 'Security Group ID', 'Security Group Name'), prefix: false)
          compute.security_groups.sort_by(&:name).each do |security_group|
            env[:ui].info(format('%-37s %s', security_group.id, security_group.name), prefix: false)
          end

          @app.call(env)
        end
      end
    end
  end
end
