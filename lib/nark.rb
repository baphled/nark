require "active_support/core_ext"

require 'nark/middleware'
require 'nark/exceptions'
require 'nark/plugin'
require 'nark/report_broker'
require 'nark/configuration'

#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Nark allowing you to gain
# valuable information on the service you are currently running.
#
module Nark
  include Nark::ReportBroker
  include Nark::Plugin

  #
  # All Nark class variables are settable via this configuration method.
  #
  # This means that configuration settings are dynamically added dependant on
  # what variables you expose via your plugins to Nark.
  #
  # TODO: Refactor so only specific class variables, possibly only setters, are exposed via our plugins.
  #
  class << self
    extend Forwardable

    def_delegators :'Nark::Configuration',
      :settings_path, :settings_path=

    def_delegators :'Nark::Configuration',
      :plugins_paths,
      :plugins_path,
      :plugin_destination

    def configure
      yield self
      true
    end
  end
end
