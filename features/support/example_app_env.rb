require 'rack/test'
require "sinatra"

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'nark/reporter/http'

class DummyApp < Sinatra::Base
  get '/' do
    'the best response eva!'
  end
end

module AppHelper
  # Rack-Test expects the app method to return a Rack application
  def app
    Rack::Builder.new do
      use Nark::Middleware
      use Nark::Reporter::HTTP
      run DummyApp
    end
  end
end

World(Rack::Test::Methods, AppHelper)

Before('@middleware') do
  #set the application and rack test methods
end

After('@middleware') do
  #unset the application and rack test methods
end
