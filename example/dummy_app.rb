require "sinatra"
require './plugins/requests'

class DummyApp < Sinatra::Base
  get '/' do
    Nark.available_plugins.inspect
  end
end
