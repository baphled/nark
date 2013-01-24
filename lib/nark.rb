require "active_support/core_ext"

require 'nark/middleware'
require 'nark/exceptions'
require 'nark/plugin'
require 'nark/report_broker'

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
  # All Rack::Tracker class variables are settable via this configuration method.
  #
  # This means that configuration settings are dynamically added dependant on
  # what variables you expose via your plugins to Rack::Tracker.
  #
  # TODO: Refactor so only specific class variables, possibly only setters, are exposed via our plugins.
  #
  class << self
    def configure
      yield self
      true
    end

    def app app
      Rack::Builder.new do
        # TODO: Determine whether this belongs here or not. Feels like part of the middlewares job.
        Nark.reporters.each do |reporter|
          use reporter
        end
        use Nark::Middleware
        run app
      end
    end
  end
end
