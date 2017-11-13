require "spec_helper"

describe Nark::Events do
  let(:event_hook) { Nark::Event.new type: :before_call, method_block: Proc.new {}, plugin: 'new_plugin' }

  class Wrapper
    include Nark::Events
  end

  subject { Wrapper }

  describe "#events" do
    after :each do
      subject.remove_trigger(:new_plugin)
    end

    it "stores a list of events" do
      expect(subject.events).to be_an(Array)
    end

    it "takes a hash" do
      expect {
        subject.events << event_hook
      }.not_to raise_error
    end

    it "takes a Nark event" do
      expect {
        subject.add_trigger(event_hook)
      }.not_to raise_error
    end
  end

  describe "#add_trigger" do
    after :each do
      subject.remove_trigger(:new_plugin)
    end

    it "adds a new event" do
      expect(subject.events).to receive(:<<).and_return(event_hook)

      subject.add_trigger event_hook
    end

    it "should only take event objects" do
      event = {}
      expect {
        subject.add_trigger event
      }.to raise_exception(Nark::Exceptions::InvalidEventType)
    end

    describe "a duplication event" do
      let(:duplicate_event_hook) { Nark::Event.new type: :before_call, method_block: Proc.new {}, plugin: 'new_plugin' }
      let(:alternate_event_hook) { Nark::Event.new type: :after_call, method_block: Proc.new {}, plugin: 'new_plugin' }

      it "shares the same method block" do
        subject.add_trigger event_hook
        expect {
          subject.add_trigger(duplicate_event_hook)
        }.to raise_exception(Nark::Exceptions::DuplicateEvent)
      end

      it "accpets events with a different type" do
        subject.add_trigger event_hook
        expect {
          subject.add_trigger(alternate_event_hook)
        }.not_to raise_error
      end
    end
  end

  describe "#remove_trigger" do
    before :each do
      subject.add_trigger(event_hook)
    end

    it "can remove a plugin event" do
      subject.remove_trigger(:new_plugin)

      expect(subject.events).not_to include(event_hook)
    end
  end

  describe "#trigger" do
    let(:event_hook) { Nark::Event.new type: :before_call, method_block: Proc.new { 2 }, plugin: 'new_plugin' }
    let(:env) { double }

    before :each do
      subject.add_trigger(event_hook)
    end

    it 'does something' do
      subject.trigger(:before_call, env)
    end

    it "finds an event associated to an event hook" do
      expect(event_hook.method_block).to receive(:call).with(env)

      subject.trigger(:before_call, env)
    end

    it "does not find an event hook" do
      expect(event_hook.method_block).not_to receive(:call)

      subject.trigger(:non_existent_event, env)
    end
  end
end
