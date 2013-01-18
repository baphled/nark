module Nark
  module Events
    module InstanceMethods
    end

    module ClassMethods
      #
      # Keeps tracks of the events to be triggered.
      #
      # We don't want this accessible as it is only really for internal
      # use
      #
      protected

      @@events = []

      public

      def add event
        events << event
      end

      #
      # Accessor for the events class instance
      #
      def events
        @@events
      end

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
        events.select do |event_hook|
          event_hook[:hook].to_sym == event.to_sym
        end
      end
    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
      receiver.extend         ClassMethods
    end
  end
end
