# frozen_string_literal: true

module VagrantPlugins
  module Scaleway
    module Action
      # This action reads the state of the machine and puts it in the
      # `:machine_state_id` key in the environment.
      class ReadState
        def initialize(app, _env)
          @app    = app
          @logger = Log4r::Logger.new('vagrant_scaleway::action::read_state')
        end

        def call(env)
          env[:machine_state_id] = read_state(env[:scaleway_compute], env[:machine])

          @app.call(env)
        end

        def read_state(scaleway, machine)
          return :not_created if machine.id.nil?

          # Find the machine
          server = scaleway.servers.get(machine.id)
          if server.nil?
            # The machine can't be found
            @logger.info('Machine not found, assuming it got destroyed.')
            machine.id = nil
            return :not_created
          end

          # Return the state
          server.state.to_sym
        end
      end
    end
  end
end
