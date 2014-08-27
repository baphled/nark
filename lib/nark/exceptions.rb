module Nark
  module Exceptions
    class PluginNameNotDefined < Exception; end
    class PluginNotFound < Exception; end
    class InvalidEventType < Exception; end
    class DuplicateEvent < Exception; end
    class UnableToTrackPluginBeingDefined < Exception; end
  end
end
