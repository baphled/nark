require "active_support/core_ext"

require 'nark/middleware'
require 'nark/exceptions'
require 'nark/plugin'

#
# This middleware is the basis of all tracking via rack middleware.
#
# It allows you to easily create your own tracker and simply plugin it into Nark allowing you to gain
# valuable information on the service you are currently running.
#
module Nark
  include Nark::Plugin
end
