$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'simplecov'
require 'rspec'
require "pry"
require 'rack/test'
require 'fakefs/spec_helpers'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'nark'

ENV['RACK_ENV'] = 'test'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include PluginMacro

  config.before :each do
    Nark.settings_path = 'config/nark.yml'
    Nark.available_plugins.each { |plugin| Nark::Plugin.undefine plugin[:name].to_sym }
  end
end
