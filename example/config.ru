require 'nark'
require 'nark/reporter/http'

require './dummy_app'

Nark.configure do |config|
  config.plugins_paths = 'example/plugins'
  config.load_plugins
end

use Nark::Reporter::HTTP
use Nark::Middleware
run DummyApp
