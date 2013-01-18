module Nark
  module Events
    module InstanceMethods
    end

    module ClassMethods

      protected

      #
      # Keeps tracks of the events to be triggered.
      #
      # We don't want this accessible as it is only really for internal
      # use
      #
      @@events = []

      public

      #
      # Adds an event hook.
      #
      # This is used to fire off custom messages when Nark is running.
      #
      def add_trigger event
        events << event
      end

      #
      # Remove all hooks relating to a given plugin
      #
      # This is primarily used when a plugin is undefined
      #
      def remove_trigger plugin_name
        events.reject! { |event| event[:plugin] == plugin_name.to_s }
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

      #
      # Accessor for the events class instance
      #
      # FIXME: This should be immutable
      #
      def events
        @@events
      end

      protected

      #
      # Works out which hooks should be triggered
      #
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
