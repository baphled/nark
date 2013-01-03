require 'spec_helper'

describe Rack::Tracker::Plugins::DSL do
  describe "#new" do
    it "allows me to create a new plugin" do
      Rack::Tracker::DSL.new :suttin_cool do
      end
      expect {
        Rack::Tracker::Plugins::SuttinCool
      }.to_not raise_error NameError
    end

    it "keeps track of the current plugin being defined" do
      Rack::Tracker::DSL.new :a_random_plugin do
        Rack::Tracker.plugin_variables :total_requests => 0
      end

      Rack::Tracker::DSL.currently_defining.should eql :a_random_plugin
    end

    context "defining class variables" do
      it "allows me to define a class method for the plugin" do
        Rack::Tracker::DSL.new :a_cool_plugin do
          Rack::Tracker.plugin_variables :total_requests => 0
        end
        class RandomPluginWrapper
          include Rack::Tracker::Plugins::ACoolPlugin
        end
        RandomPluginWrapper.total_requests.should eql 0
      end
    end

    it "allows me to add an event hook"
    it "allows me to add plugin variables"
  end
end
