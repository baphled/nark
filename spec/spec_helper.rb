$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require "pry"
require 'rack/test'
require 'rack_tracker'

ENV['RACK_ENV'] = 'test'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/../lib/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/../lib/rack_tracker/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end
