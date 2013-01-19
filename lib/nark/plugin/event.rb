module Nark
  module Plugin
    class Event
      attr_accessor :type
      attr_accessor :method_block
      attr_accessor :plugin

      def initialize params
        @type = params[:type]
        @method_block = params[:method_block]
        @plugin = params[:plugin]
      end
    end
  end
end
