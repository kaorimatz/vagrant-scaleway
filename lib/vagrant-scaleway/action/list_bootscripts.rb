module VagrantPlugins
  module Scaleway
    module Action
      class ListBootscripts
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          compute = env[:scaleway_compute]

          env[:ui].info(format('%-37s %-7s %s', 'Bootscript ID', 'Arch', 'Bootscript Title'), prefix: false)
          compute.bootscripts.sort_by(&:title).each do |bootscript|
            env[:ui].info(format('%-37s %-7s %s', bootscript.id, bootscript.architecture, bootscript.title), prefix: false)
          end

          @app.call(env)
        end
      end
    end
  end
end
