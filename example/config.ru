require 'nark'
require 'nark/reporter/http'

require './dummy_app'

Nark.configure do |config|
  config.plugins_paths = 'example/plugins'
  config.load_plugins
end

use Nark::Middleware
use Nark::Reporter::HTTP
run DummyApp
