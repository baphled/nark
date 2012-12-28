require "spec_helper"

describe Rack::Tracker do

  describe "#plugins" do
    it "provides plugins used by default" do
      Rack::Tracker.plugins.should eql ['requests']
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
end
