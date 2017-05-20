module VagrantPlugins
  module Scaleway
    module Action
      class ListImages
        def initialize(app, _env)
          @app = app
        end

        def call(env)
          compute = env[:scaleway_compute]

          env[:ui].info(format('%-37s %-26s %-7s %-36s %s', 'Image ID', 'Created At', 'Arch', 'Default Bootscript', 'Image Name'), prefix: false)
          compute.images.sort_by(&:name).each do |image|
            created_at = Time.parse(image.creation_date)
            bootscript = image.default_bootscript && image.default_bootscript.title
            env[:ui].info(format('%-37s %-26s %-7s %-36s %s', image.id, created_at, image.arch, bootscript, image.name), prefix: false)
          end

          @app.call(env)
        end
      end
    end
  end
end
