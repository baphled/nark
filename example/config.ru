require 'nark'

require './dummy_app'

Nark.configure do |config|
  config.plugins_paths = 'example/plugins'
  config.load_plugins
end

use Nark::Middleware
run DummyApp
