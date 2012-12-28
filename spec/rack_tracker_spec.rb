require "spec_helper"

describe Rack::Tracker do
  describe "#plugins" do
    it "provides a list of plugins available"

    it "provides plugins used by default" do
      Rack::Tracker.plugins.should eql ['request_tracker']
    end
  end
end
