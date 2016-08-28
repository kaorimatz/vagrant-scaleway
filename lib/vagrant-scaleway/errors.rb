module VagrantPlugins
  module Scaleway
    module Errors
      class VagrantScalewayError < Vagrant::Errors::VagrantError
        error_namespace('vagrant_scaleway.errors')
      end

      class FogError < VagrantScalewayError
        error_key(:fog_error)
      end

      class InternalFogError < VagrantScalewayError
        error_key(:internal_fog_error)
      end

      class ServerReadyTimeout < VagrantScalewayError
        error_key(:server_ready_timeout)
      end
    end
  end
end
