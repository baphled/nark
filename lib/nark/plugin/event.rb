module Nark
  module Plugin
    class Event
      attr_accessor :hook

      def initialize params
        @hook = params[:hook]
      end
    end
  end
end
