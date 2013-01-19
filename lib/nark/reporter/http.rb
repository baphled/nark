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
        endpoints = manipulate_defined_methods do |endpoint|
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

      get '/nark/plugin/stats' do
        stats = manipulate_defined_methods do |endpoint|
          { endpoint.to_sym => Nark.public_send(endpoint) }
        end
        JSON.pretty_generate :stats => stats
      end

      #
      # GET /nark/:plugin_method
      #
      # Exposes the plugins class method and returns the data.
      #
      get "/nark/:plugin_method" do
        plugin_method = params[:plugin_method]
        if Nark::Plugin.defined_methods.include? plugin_method.to_sym
          JSON.pretty_generate plugin_method.to_sym => Nark.public_send(plugin_method)
        else
          status 404
        end
      end

      protected

      def manipulate_defined_methods &block
        Nark::Plugin.defined_methods.collect do |endpoint|
          yield endpoint
        end
      end
    end
  end
end
