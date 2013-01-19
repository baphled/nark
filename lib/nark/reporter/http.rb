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

      get '/nark' do
        endpoints = Nark::Plugin.defined_methods.collect do |endpoint|
          { :url => "/nark/#{endpoint}", :rel => "plugin_method" }
        end
        endpoints << { :url => "/nark", :rel => "self" }
        response = { :endpoints => endpoints }
        JSON.pretty_generate response
      end

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
          JSON.pretty_generate params[:plugin_method].to_sym => Nark.public_send(params[:plugin_method])
        else
          status 404
        end
      end
    end
  end
end
