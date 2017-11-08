require "spec_helper"

describe Nark::Events do
  let(:event_hook) { Nark::Event.new type: :before_call, method_block: Proc.new {}, plugin: 'new_plugin' }

  class Wrapper
    include Nark::Events
  end

  describe "#events" do
    after :each do
      Wrapper.remove_trigger :new_plugin
    end

    it "stores a list of events" do
      Wrapper.events.should be_an Array
    end

    it "takes a hash" do
      Wrapper.events << event_hook
    end

    it "takes a Nark event" do
      Wrapper.add_trigger event_hook
    end
  end

  describe "#add_trigger" do
    after :each do
      Wrapper.remove_trigger :new_plugin
    end

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
      let(:duplicate_event_hook) { Nark::Event.new type: :before_call, method_block: Proc.new {}, plugin: 'new_plugin' }
      let(:alternate_event_hook) { Nark::Event.new type: :after_call, method_block: Proc.new {}, plugin: 'new_plugin' }

      it "shares the same method block" do
        Wrapper.add_trigger event_hook
        expect {
          Wrapper.add_trigger duplicate_event_hook
        }.to raise_error Nark::Exceptions::DuplicateEvent
      end

      it "accpets events with a different type" do
        Wrapper.add_trigger event_hook
        expect {
          Wrapper.add_trigger alternate_event_hook
        }.not_to raise_error
      end
    end
  end

  describe "#remove_trigger" do
    before :each do
      Wrapper.add_trigger event_hook
    end

    it "can remove a plugin event" do
      Wrapper.remove_trigger :new_plugin
      Wrapper.events.should_not include event_hook
    end
  end

  describe "#trigger" do
    context "event is found" do
      it "calls an event"
      it "the event can make use the of the environment"
    end

    context "event not found" do
      it "does not call any events"
    end
  end
end
