require 'rack/test'
require "sinatra"

class DummyApp < Sinatra::Base
  get '/' do
    'the best response eva!'
  end
end

require 'rack/test'
module AppHelper
  # Rack-Test expects the app method to return a Rack application
  def app
    Rack::Builder.new do
      use Nark::Middleware
      run DummyApp
    end
  end
end

World(Rack::Test::Methods, AppHelper)

Before('@webapp') do
  #set the application and rack test methods
end

After('@webapp') do
  #unset the application and rack test methods
end
