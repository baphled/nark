require 'spec_helper'
require "#{File.dirname(__FILE__)}/../../../lib/plugins/repository_revision"

describe Rack::Tracker::Plugins::DSL do
  describe "#new" do
    it "allows me to create a new plugin" do
      Rack::Tracker::Plugins::DSL.new :suttin_cool do
      end
      expect {
        Rack::Tracker::Plugins::SuttinCool
      }.to_not raise_error NameError
    end

    it "allows me to define a class method for the plugin" do
      Rack::Tracker::Plugins::DSL.new :a_cool_plugin do
        Rack::Tracker.plugin_variables :last_request_time => nil
      end
      class RandomPluginWrapper
        include Rack::Tracker::Plugins::ACoolPlugin
      end
      RandomPluginWrapper.total_requests.should eql 0
    end

    it "allows me to add an event hook"
    it "allows me to add plugin variables"
  end
end
