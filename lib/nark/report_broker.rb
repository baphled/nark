require_relative 'reporter/http'

module Nark
  #
  # Handles which reporters should be included in the middle ware.
  #
  # This is used by Nark to determine whether any reporters are needed before
  # setting up the application.
  #
  # This functionality relies on the fact that reporters are setup via Nark's
  # configuration block.
  #
  # If no reporters are defined within the configuration block then no
  # reporters will be added to the middleware.
  #
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
