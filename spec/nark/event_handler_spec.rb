require "spec_helper"

describe Nark::EventHandler do
  class Wrapper
    include Nark::EventHandler
  end

  describe "#trigger_hook" do
    it "triggers before and after hooks at least twice" do
      env = {}
      wrapper = Wrapper.new
      Wrapper.events << {hook: :before_call, plugin_method: Proc.new {}, plugin: 'new_plugin'}
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
end
