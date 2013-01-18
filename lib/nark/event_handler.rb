module Nark
  module EventHandler
    module InstanceMethods
      #
      # Triggers an event.
      #
      # This is used internally to determine whether there are any events to be
      # triggered.
      #
      def trigger event, env
        triggered_events(event).each do |hook|
          Nark.class_eval 'hook[:plugin_method].call env'
        end
      end

      def triggered_events event
        self.class.events.select do |listener|
          listener[:hook].to_sym == event.to_sym
        end
      end
    end

    module ClassMethods
      #
      # Keeps tracks of the events to be triggered.
      #
      @@events = []

      #
      # Accessor for the events class instance
      #
      def events
        @@events
      end
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
      receiver.extend         ClassMethods
    end
  end
end
