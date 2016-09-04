require 'vagrant-scaleway/action'

module VagrantPlugins
  module Scaleway
    module Command
      class Root < Vagrant.plugin('2', :command)
        def self.synopsis
          'queries Scaleway for available resources'
        end

        def initialize(argv, env)
          @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

          @subcommands = Vagrant::Registry.new
          @subcommands.register(:bootscripts) do
            require File.expand_path('../bootscripts', __FILE__)
            Bootscripts
          end
          @subcommands.register(:images) do
            require File.expand_path('../images', __FILE__)
            Images
          end

          super(argv, env)
        end

        def execute
          if @main_args.include?('-h') || @main_args.include?('--help')
            # Print the help for all the scaleway commands.
            return help
          end

          command_class = @subcommands.get(@sub_command.to_sym) if @sub_command
          return help if !command_class || !@sub_command
          @logger.debug("Invoking command class: #{command_class} #{@sub_args.inspect}")

          # Initialize and execute the command class
          command_class.new(@sub_args, @env).execute
        end

        def help
          opts = OptionParser.new do |opts|
            opts.banner = 'Usage: vagrant scaleway <subcommand> [<args>]'
            opts.separator ''
            opts.separator 'Available subcommands:'

            # Add the available subcommands as separators in order to print them
            # out as well.
            keys = []
            @subcommands.each { |key, _value| keys << key.to_s }

            keys.sort.each do |key|
              opts.separator "     #{key}"
            end

            opts.separator ''
            opts.separator 'For help on any individual subcommand run `vagrant scaleway <subcommand> -h`'
          end

          @env.ui.info(opts.help, prefix: false)
        end
      end
    end
  end
end
