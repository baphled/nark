require 'sinatra'

module Nark
  module Reporter
    class HTTP < Sinatra::Base
      set :port, 9494

      get "/nark/available_plugins" do
        JSON.pretty_generate :plugins => Nark.available_plugins
      end

      get "/nark/status_codes" do
        JSON.pretty_generate Nark.status_codes
      end
    end
  end
end
