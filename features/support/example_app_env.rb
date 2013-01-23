require "rack/test"
require "sinatra"
require 'capybara/cucumber'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'nark/reporter/http'

class DummyApp < Sinatra::Base
  get '/' do
    'the best response eva!'
  end
end

Before('@http-reporter') do
  Nark.configure do |c|
    c.reporters = [:HTTP]
  end
end

Before('@app-call, @middleware, @reporting-api') do
  # TODO: Setup HTTP reporter
  Capybara.app = Nark.app(DummyApp)
end

After('@app-call, @middleware, @reporting-api, @reporter') do
  Capybara.app = nil
end
