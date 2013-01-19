module Nark
  module Plugin
    class Event
      attr_accessor :type
      attr_accessor :method_block
      attr_accessor :plugin

      attr_accessor :attributes

      def initialize params
        @attributes = params
        @type = params[:type]
        @method_block = params[:method_block]
        @plugin = params[:plugin]
      end

      def to_hash
        attributes
      end
    end
  end
end
