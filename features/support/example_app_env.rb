require 'bundler'

require 'nark'
require 'rack/test'
require "sinatra"

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

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
