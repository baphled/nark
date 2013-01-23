require 'nark'
require 'nark/reporter/http'

require './dummy_app'

Nark.configure do |config|
  config.plugins_paths = 'example/plugins'
  config.load_plugins
end

run Nark.app DummyApp
