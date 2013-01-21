require "sinatra"

class DummyApp < Sinatra::Base
  get '/' do
    Nark.available_plugins.inspect
  end
end
