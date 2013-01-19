require 'sinatra'

module Nark
  module Reporter
    class HTTP < Sinatra::Base
      set :port, 9494

      get "/nark/available_plugins" do
        JSON.pretty_generate :plugins => Nark.available_plugins
      end

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
