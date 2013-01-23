require_relative 'reporter/http'

module Nark
  module ReportBroker
    module ClassMethods
      @@reporters = []
      def reporters
        @@reporters
      end

      def reporters= reporters
        @@reporters = reporters.collect do |reporter|
          "Nark::Reporter::#{reporter.to_s}".constantize
        end
      end
    end
  
    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end
