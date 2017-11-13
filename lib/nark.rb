require "active_support"
require "active_support/core_ext"
require "active_support/deprecation"

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
  include Nark::Plugin

  #
  # Basic singleton class primarily used to configure and setup Nark.
  #
  class << self
    extend Forwardable

    def_delegators :'Nark::ReportBroker',
      :reporters, :reporters=

    def_delegators :'Nark::Configuration',
      :settings_path, :settings_path=

    def_delegators :'Nark::Configuration',
      :plugins_path

    def_delegators :'Nark::Configuration',
      :configure, :config
  end
end
