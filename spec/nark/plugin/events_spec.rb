require "spec_helper"

describe Nark::Events do
  let(:event_hook) { Nark::Event.new type: :before_call, method_block: Proc.new {}, plugin: 'new_plugin' }

  class Wrapper
    include Nark::Events
  end

  describe "#events" do
    it "stores a list of events" do
      Wrapper.events.should be_an Array
    end

    it "takes a hash" do
      Wrapper.events << event_hook
    end

    it "takes a Nark event" do
      params = {hook: :before_call, plugin_method: Proc.new {}, plugin: 'new_plugin'}
      event = Nark::Plugin::Event.new params
      Wrapper.add_trigger event
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
