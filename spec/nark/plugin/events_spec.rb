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
      Wrapper.add_trigger event_hook
    end
  end

  describe "#add_trigger" do
    it "adds a new event" do
      Wrapper.events.should_receive(:<<).and_return event_hook
      Wrapper.add_trigger event_hook
    end

    it "should only take event objects" do
      event = {}
      expect {
        Wrapper.add_trigger event
      }.to raise_error Nark::Exceptions::InvalidEventType
    end

    describe "a duplication event" do
      it "shares the same method block" do
        Wrapper.add_trigger event_hook
        expect {
          Wrapper.add_trigger event_hook
        }.to raise_error Nark::Exceptions::DuplicateEvent
      end
    end
  end

  describe "#is_duplicate?" do
    it "is true when the trigger already exists" do
      Wrapper.add_trigger event_hook
      Wrapper.is_duplicate?(event_hook).should be_true
    end
  end

  describe "#remove_trigger" do
    it "can remove a plugin event" do
      Wrapper.events.should_receive(:reject!).and_return event_hook
      Wrapper.remove_trigger :new_plugin
    end
  end
end
