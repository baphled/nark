require 'nark'

require './dummy_app'

use Nark::Middleware
run DummyApp
