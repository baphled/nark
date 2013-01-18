module Nark
  module EventHandler
    module InstanceMethods
      #
      # Triggers an event.
      #
      # This is used internally to determine whether there are any events to be
      # triggered.
      #
      def trigger_hook hook, env
        event_hooks = Nark::EventHandler.events.select do |listener|
          listener[:hook].to_sym == hook.to_sym
        end
        event_hooks.each do |before_hook|
          Nark.class_eval 'before_hook[:plugin_method].call env'
        end
      end
    end

    class << self
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
    end
  end
end
