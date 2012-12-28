require "spec_helper"

describe Rack::Tracker do
  describe "#plugins" do
    it "provides plugins used by default" do
      Rack::Tracker.plugins.should eql ['request_tracker']
    end
  end

  describe "#available_plugins" do
    it "provides a list of plugins available" do
      pending 'Yet to implement...'
      Rack::Tracker.available_plugins.should eql ['request_tracker', 'request_time_tracker']
    end
  end
end
