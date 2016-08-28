module VagrantPlugins
  module Scaleway
    module Action
      # This action reads the SSH info for the machine and puts it into the
      # `:machine_ssh_info` key in the environment.
      class ReadSSHInfo
        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_scaleway::action::read_ssh_info')
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env[:scaleway_compute], env[:machine])

          @app.call(env)
        end

        def read_ssh_info(scaleway, machine)
          return nil if machine.id.nil?

          # Find the machine
          server = scaleway.servers.get(machine.id)
          if server.nil?
            # The machine can't be found
            @logger.info("Machine couldn't be found, assuming it got destroyed.")
            machine.id = nil
            return nil
          end

          # read attribute override
          ssh_host_attribute = machine.provider_config.ssh_host_attribute
          # default host attributes to try. NOTE: Order matters!
          ssh_attrs = %i(public_ip_address public_dns_name private_ip_address private_dns_name)
          ssh_attrs = (Array(ssh_host_attribute) + ssh_attrs).uniq if ssh_host_attribute
          # try each attribute, get out on first value
          host = nil
          while !host && (attr = ssh_attrs.shift)
            begin
              host = server.send(attr)
            rescue NoMethodError
              @logger.info("SSH host attribute not found #{attr}")
            end
          end

          { host: host, port: 22, username: 'root' }
        end
      end
    end
  end
end
