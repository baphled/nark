require "spec_helper"

describe Rack::Tracker do

  describe "#plugins" do
    it "has no plugins set by default" do
      Rack::Tracker.plugins.should eql []
    end

    it "provides does not manage a plugins name" do
      class Rack::Tracker
        include Rack::TrackerPlugin::RequestTimes
      end
      Rack::Tracker.plugins.should include 'request_times'
    end
  end

  describe "#available_plugins" do
    it "provides a list of plugins available" do
      Rack::Tracker.available_plugins.should eql ['requests', 'request_times']
    end
  end

  describe "#add_plugin" do
    context "specifying a list of plugins" do
      it "includes all listed plugins" do
        Rack::Tracker.add_plugins ['requests']
        Rack::Tracker.ancestors.should include Rack::TrackerPlugin::Requests
      end

      it "does not include plugins not in the list"
    end

    context "plugin is not found" do
      it "should throw an exception"
    end
  end
end
