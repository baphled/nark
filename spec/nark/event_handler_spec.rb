require "spec_helper"

describe Nark::EventHandler do
  describe "#events" do
    it "stores a list of events" do
      Nark::EventHandler.events.should be_an Array
    end

    it "takes a hash" do
      Nark::EventHandler.events << {hook: :before_call, plugin_method: Proc.new {}, plugin: 'new_plugin'}
    end
  end
end
