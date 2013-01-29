require "rack/test"
require "sinatra"
require 'capybara/cucumber'

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
  Capybara.app = Nark::Middleware.with(DummyApp)
end

After('@app-call, @middleware, @reporting-api, @reporter') do
  Capybara.app = nil
end
