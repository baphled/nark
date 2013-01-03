module Rack::TrackerPlugin
  class NotFound < Exception; end
  class RevisionNotFound < Exception; end
end

module Rack
  module Tracker
    module Exceptions
      class UnableToTrackPluginBeingDefined < Exception; end
    end
  end
end
