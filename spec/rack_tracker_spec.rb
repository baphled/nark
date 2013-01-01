require "spec_helper"

describe Rack::Tracker do
  describe "#configure" do
    it "allows be to add plugin directories" do
      plugin_path = File.join ::File.dirname(__FILE__), 'fixtures/plugins'
      Rack::Tracker.configure do |c|
        c.plugins_paths << plugin_path
      end
      Rack::Tracker.plugins_paths.count.should eql 2
    end

    it "allows to specify which plugins to include" do
      plugin_path = File.join ::File.dirname(__FILE__), 'fixtures/plugins'
      Rack::Tracker.configure do |c|
        c.plugins_paths << plugin_path
	c.add_plugins [:dummy_plugin, :requests, :request_times]
      end
      Rack::Tracker.plugins.should eql ["dummy_plugin", "request_times", "requests"]
    end
  end
end
