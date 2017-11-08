require "spec_helper"

describe Nark::Plugin do
  it "stores an array of plugin available" do
    expect(Nark.available_plugins).to be_an(Array)
  end

  describe "#available_plugins" do
    let(:requests) { create_plugin(:requests) }

    it "should not include class_methods" do
      expect(Nark.available_plugins).not_to include('class_methods')
    end

    it "should not include instance_methods" do
      expect(Nark.available_plugins).not_to include('instance_methods')
    end

    it "automatically includes a defined module" do
      Nark::Plugin.define :requests, &requests

      expected_hash = {
        :name => 'requests',
        :description => 'Fallback description: Use the description macro to define the plugins description'
      }

      expect(Nark.available_plugins).to include(expected_hash)
    end
  end

  describe "#load_plugins" do
    let(:plugin_path) { File.absolute_path File.join File.dirname(__FILE__), "..", "..", 'plugins' }

    it "gets the defined plugin path" do
      expect(Nark).to receive(:defined_plugin_path).and_return(plugin_path)

      Nark.load_plugins
    end

    it "requires all plugins found" do
      Nark.load_plugins

      expect(Nark.available_plugins.count).to eql(4)
    end

    it "doesn't load the same plugins more than once" do
      Nark.load_plugins
      Nark.load_plugins

      expect(Nark.available_plugins.count).to eql(4)
    end
  end

  describe "#defined_methods" do
    it "can track defined plugin messages" do
      expect(Nark::Plugin.defined_methods).to eql([])
    end

    it "exposes only accessors" do
      Nark.load_plugins

      expect(Nark::Plugin.defined_methods).not_to include(:total_requests=)
      expect(Nark::Plugin.defined_methods).to include(:total_requests)
    end
  end
end
