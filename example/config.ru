require 'nark'
require 'nark/reporter/http'

require './dummy_app'

Nark.configure do |config|
  config.load_plugins
  config.reporters = [:HTTP]
end

run Nark::Middleware.with DummyApp
