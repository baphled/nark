require "spec_helper"

describe Nark::Events do
  let(:event_hook) { { hook: :before_call, plugin_method: Proc.new {}, plugin: 'new_plugin' } }

  class Wrapper
    include Nark::Events
  end

  describe "#events" do
    it "stores a list of events" do
      Wrapper.events.should be_an Array
    end

    it "takes a hash" do
      Wrapper.events << {hook: :before_call, plugin_method: Proc.new {}, plugin: 'new_plugin'}
    end
  end

  describe "#add_trigger" do
    it "adds a new event" do
      Wrapper.events.should_receive(:<<).and_return event_hook
      Wrapper.add_trigger event_hook
    end
  end

  describe "#remove_trigger" do
    it "can remove a plugin event" do
      Wrapper.events.should_receive(:reject!).and_return event_hook
      Wrapper.remove_trigger :new_plugin
    end
  end
end
