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
        triggered(event).each do |triggered_event|
          Nark.class_eval 'triggered_event[:plugin_method].call env'
        end
      end

      protected

      def triggered event
        self.class.events.select do |event_hook|
          event_hook[:hook].to_sym == event.to_sym
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
