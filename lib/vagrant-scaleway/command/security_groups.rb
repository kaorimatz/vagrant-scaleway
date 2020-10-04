# frozen_string_literal: true

module VagrantPlugins
  module Scaleway
    module Command
      class SecurityGroups < Vagrant.plugin('2', :command)
        def execute
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant scaleway security-groups [options]'
          end

          argv = parse_options(opts)
          return unless argv

          with_target_vms(argv, provider: :scaleway) do |machine|
            machine.action('list_security_groups')
          end
        end
      end
    end
  end
end
