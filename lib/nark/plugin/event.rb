require_relative 'events'

module Nark
  module Plugin
    #
    # An event based value object allowing use to easily deal with event based functionality.
    #
    # Used to keep track and interact with a plugin's triggers.
    #
    # Essentially this is a value object used to store a plugins event block which is then used by the middleware to
    # trigger at the right time.
    #
    # TODO: Rename to Trigger
    #
    class Event
      #
      # Only allow the object to change the state of the event
      #
      private

      #
      # Protect the the object from being changed externally
      #
      attr_writer :type
      attr_writer :method_block
      attr_writer :plugin

      #
      # Used to simplify the way parameters are returned and stored
      #
      attr_accessor :attributes

      public

      #
      # Stores the type of event
      #
      attr_reader :type

      #
      # Stores the event block to be triggered
      #
      attr_reader :method_block

      #
      # Stores the name of the plugin that the event belongs to
      #
      attr_reader :plugin

      #
      # Initialise the new Event
      #
      def initialize params
        @attributes = params
        @type = params[:type]
        @method_block = params[:method_block]
        @plugin = params[:plugin]
      end

      #
      # Checks the exists of the plugin in the events collection
      #
      def exists?
        Nark::Plugin.events.find { |event| method_block == event.method_block  }
      end

      #
      # Returns a hash of the events attributes
      #
      def to_hash
        attributes
      end
    end
  end
end
