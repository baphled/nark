require "spec_helper"

describe Nark::Plugin do
  it "stores an array of plugin available" do
    Nark.available_plugins.should be_an Array
  end

  describe "#available_plugins" do
    let(:requests) { create_plugin(:requests) }

    it "should not include class_methods" do
      Nark.available_plugins.should_not include 'class_methods'
    end

    it "should not include instance_methods" do
      Nark.available_plugins.should_not include 'instance_methods'
    end

    it "automatically includes a defined module" do
      Nark::Plugin.define :requests, &requests
      Nark.available_plugins.should include 'requests'
    end
  end

  describe "#load_plugins" do
    it "gets the defined plugin path" do
      plugin_path = File.absolute_path File.join File.dirname(__FILE__), "..", "..", 'plugins'
      Nark.should_receive(:defined_plugin_path).and_return plugin_path
      Nark.load_plugins
    end

    it "requires all plugins found" do
      Nark.load_plugins
      Nark.available_plugins.count.should eql 4
    end
  end

  describe "#defined_methods" do
    it "can track defined plugin messages" do
      Nark::Plugin.defined_methods.should eql []
    end

    it "exposes only accessors" do
      Nark.load_plugins
      Nark::Plugin.defined_methods.should_not include :total_requests=
        Nark::Plugin.defined_methods.should include :total_requests
    end
  end
end
