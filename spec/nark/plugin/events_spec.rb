require "spec_helper"

describe Nark::Events do
  let(:event_hook) { { hook: :before_call, plugin_method: Proc.new {}, plugin: 'new_plugin' } }

  class Wrapper
    include Nark::Events
  end

  describe "#trigger_hook" do
    it "triggers before and after hooks at least twice" do
      env = {}
      wrapper = Wrapper.new
      Wrapper.add event_hook
      wrapper.should_receive(:trigger_hook)
      wrapper.trigger_hook :before_call, env
    end
  end

  describe "#events" do
    it "stores a list of events" do
      Wrapper.events.should be_an Array
    end

    it "takes a hash" do
      Wrapper.events << {hook: :before_call, plugin_method: Proc.new {}, plugin: 'new_plugin'}
    end
  end

  describe "#add" do
    it "adds a new event" do
      Wrapper.events.should_receive(:<<).and_return event_hook
      Wrapper.add event_hook
    end
  end
end
