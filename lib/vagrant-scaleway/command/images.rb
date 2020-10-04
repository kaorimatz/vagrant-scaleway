# frozen_string_literal: true

module VagrantPlugins
  module Scaleway
    module Command
      class Images < Vagrant.plugin('2', :command)
        def execute
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant scaleway images [options]'
          end

          argv = parse_options(opts)
          return unless argv

          with_target_vms(argv, provider: :scaleway) do |machine|
            machine.action('list_images')
          end
        end
      end
    end
  end
end
