require "spec_helper"

describe Nark::Plugin do

  it "stores an array of plugin available" do
    Nark::Middleware.new stub(:app, :call => 'foo')
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

    it "provides a list of all available plugins"

    it "automatically includes a defined module" do
      Nark::Plugin.define :requests, &requests
      Nark.available_plugins.should include 'requests'
    end
  end
end
