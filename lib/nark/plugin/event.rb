module Nark
  module Plugin
    class Event
      attr_accessor :trigger_type

      def initialize params
        @trigger_type = params[:trigger_type]
      end
    end
  end
end
