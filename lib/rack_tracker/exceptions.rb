module Rack
  module Tracker
    module Exceptions
      class PluginNotFound < Exception; end
      class UnableToTrackPluginBeingDefined < Exception; end
    end
  end
end
