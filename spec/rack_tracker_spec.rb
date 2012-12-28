require "spec_helper"

describe Rack::Tracker do

  describe "#plugins" do
    it "has no plugins set by default" do
      Rack::Tracker.plugins.should eql []
    end

    it "provides does not manage a plugins name" do
      Rack::Tracker.require_plugins
      Rack::Tracker.add_plugins ['request_times']
      Rack::Tracker.plugins.should include 'request_times'
    end
  end

  describe "#available_plugins" do
    it "provides a list of plugins available"
  end

  describe "#add_plugin" do
    context "plugins are required" do
      before :each do
        Rack::Tracker.require_plugins
      end

      it "includes all listed plugins" do
        Rack::Tracker.add_plugins ['requests']
        Rack::Tracker.included_plugins.should include Rack::TrackerPlugin::Requests
      end
    end

    context "plugin is not found" do
      it "should throw an exception" do
        expect {
          Rack::Tracker.add_plugins ['flakey']
        }.to raise_error Rack::TrackerPlugin::NotFound
      end
    end
  end

  describe "#require_plugins" do
    it "loads all plugins to the TrackerPlugin namespace" do
      Rack::Tracker.require_plugins
      Rack::Tracker.available_plugins.should eql ['request_times', 'requests']
    end
  end

  describe "#plugins_paths" do
    it "stores the default plugins path" do
      Rack::Tracker.plugins_paths.should_not be_empty
      Rack::Tracker.available_plugins.should eql ['request_times', 'requests']
    end
  end

  describe "#add_plugin_path" do
    it "stores the plugin path"
    it "throws an exception if no plugins were found"
    it "allows us to add a new path to search for plugins in"
  end
end
