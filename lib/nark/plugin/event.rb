module Nark
  module Plugin
    class Event
      attr_accessor :trigger_type
      attr_accessor :method_block
      attr_accessor :plugin

      def initialize params
        @trigger_type = params[:trigger_type]
        @method_block = params[:method_block]
        @plugin = params[:plugin]
      end
    end
  end
end
