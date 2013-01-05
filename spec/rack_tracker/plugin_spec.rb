require "spec_helper"

describe Rack::Tracker::Plugin do

  it "stores an array of plugin available" do
    Rack::Tracker::Middleware.new stub(:app, :call => 'foo')
    Rack::Tracker.available_plugins.should be_an Array
  end

  describe "#plugins" do
    it "can add a plugin" do
      Rack::Tracker::Plugin.define :requests do |plugin|
        plugin.variables :total_requests => 0

        plugin.add_hook :before_call do |env|
          Rack::Tracker.total_requests += 1
        end
      end
      Rack::Tracker.add_plugins [:requests]
      Rack::Tracker.plugins.should include 'requests'
    end
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

  describe "#add_plugin" do
    context "plugins are required" do
      it "includes all listed plugins" do
        Rack::Tracker::Plugin.define :requests do |plugin|
          plugin.variables :total_requests => 0

          plugin.add_hook :before_call do |env|
            Rack::Tracker.total_requests += 1
          end
        end
        Rack::Tracker.add_plugins [:requests]
        Rack::Tracker.included_plugins.should include Rack::Tracker::Plugin::Requests
      end
    end

    context "plugin is not found" do
      it "should throw an exception" do
        pending 'Need to revisit this'
        expect {
          Rack::Tracker.add_plugins ['flakey']
        }.to raise_error Rack::TrackerPlugin::NotFound
      end
    end
  end

  describe "#require_plugins" do
    it "loads all plugins to the TrackerPlugin namespace" do
      Rack::Tracker.available_plugins.should include 'requests'
    end
  end
end
