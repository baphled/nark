require_relative 'event'

module Nark
  #
  # Used to manage the events that a the middleware should track
  #
  # TODO: Rename to Triggers
  #
  module Events
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
        if event.class != Nark::Plugin::Event
          raise Nark::Exceptions::InvalidEventType
        elsif event.exists?
          raise Nark::Exceptions::DuplicateEvent
        else
          events << event
        end
      end

      #
      # Remove all hooks relating to a given plugin
      #
      # This is primarily used when a plugin is undefined
      #
      def remove_trigger plugin_name
        events.reject! { |event| event.plugin == plugin_name.to_s }
      end

      #
      # Triggers an event.
      #
      # This is used internally to determine whether there are any events to be
      # triggered.
      #
      # FIXME: When an event is triggered should keep it persistent
      #
      def trigger event, env
        triggered(event).each do |triggered_event|
          Nark.class_eval 'triggered_event.method_block.call env'
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
          event_hook.type.to_sym == event.to_sym
        end
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end
