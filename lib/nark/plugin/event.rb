require_relative 'events'

module Nark
  module Plugin
    #
    # Essentially this is a value object used to store a plugins event block
    # which is then used by the middleware to trigger at the right time.
    #
    class Event
      attr_reader :type
      attr_reader :method_block
      attr_reader :plugin
      attr_reader :attributes

      protected

      attr_writer :type
      attr_writer :method_block
      attr_writer :plugin
      attr_writer :attributes

      public

      def initialize params
        @attributes = params
        @type = params[:type]
        @method_block = params[:method_block]
        @plugin = params[:plugin]
      end

      def exists?
        Nark::Plugin.events.find { |event| method_block == event.method_block  }
      end

      def to_hash
        attributes
      end
    end
  end
end
