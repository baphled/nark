require "sinatra"
require './plugins/requests'

class DummyApp < Sinatra::Base
  get '/' do
    Nark.total_requests.inspect
  end
end
