# frozen_string_literal: true

require 'pathname'
require 'vagrant-scaleway/plugin'

module VagrantPlugins
  module Scaleway
    lib_path = Pathname.new(File.expand_path('vagrant-scaleway', __dir__))
    autoload :Action, lib_path.join('action')
    autoload :Errors, lib_path.join('errors')

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path('..', __dir__))
    end
  end
end
