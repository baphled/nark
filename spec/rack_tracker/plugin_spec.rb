require "spec_helper"

describe Rack::Tracker::Plugin do

  it "stores an array of plugin available" do
    Rack::Tracker::Middleware.new stub(:app, :call => 'foo')
    Rack::Tracker.available_plugins.should be_an Array
  end

  describe "#available_plugins" do
    it "should not include class_methods" do
      Rack::Tracker.available_plugins.should_not include 'class_methods'
    end

    it "should not include instance_methods" do
      Rack::Tracker.available_plugins.should_not include 'instance_methods'
    end

    it "provides a list of all available plugins"
  end

  describe "#require_plugins" do
    let(:requests) { create_plugin(:requests) }

    it "automatically includes a defined module" do
      Rack::Tracker::Plugin.define :requests, &requests
      Rack::Tracker.available_plugins.should include 'requests'
    end
  end

  describe "#listeners" do
    it "stores a list of events to listen out for" do
      Rack::Tracker.listeners.should be_an Array
    end
  end
end
