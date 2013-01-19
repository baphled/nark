require 'sinatra'

module Nark
  module Reporter
    #
    # HTTP Report layer
    #
    # Used to provide a basic HTTP layer.
    #
    # This gives users and developers the opportunity to extract information
    # from their plugin and use it in other places.
    #
    class HTTP < Sinatra::Base

      #
      # GET /nark/available_plugins
      #
      # Returns an array of plugin's that are currently being used
      #
      get "/nark/available_plugins" do
        JSON.pretty_generate :plugins => Nark.available_plugins
      end

      #
      # GET /nark/:plugin_method
      #
      # Exposes the plugins class method and returns the data.
      #
      get "/nark/:plugin_method" do
        if Nark::Plugin.defined_methods.include? params[:plugin_method].to_sym
          JSON.pretty_generate Nark.public_send params[:plugin_method]
        else
          status 404
        end
      end
    end
  end
end
