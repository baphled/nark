module Rack::Tracker::Plugin
  module DummyPlugin
    module ClassMethods
    end

    module InstanceMethods
      def do_something
        puts 'doing something'
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end

