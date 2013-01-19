module Nark
  module Plugin
    class Event
      attr_accessor :trigger_type
      attr_accessor :method_block

      def initialize params
        @trigger_type = params[:trigger_type]
        @method_block = params[:method_block]
      end
    end
  end
end
