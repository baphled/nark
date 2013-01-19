module Nark
  module Exceptions
    class PluginNotFound < Exception; end
    class InvalidEventType < Exception; end
    class DuplicateEvent < Exception; end
    class UnableToTrackPluginBeingDefined < Exception; end
  end
end
