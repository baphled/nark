require "spec_helper"

describe Nark::Macros do
  describe "#add_hook" do
    it "adds the hook to the middlewares events" do
      Nark::Plugin.events.should_receive :<<
      Nark::Plugin.define :requests do |plugin|
        plugin.variables :last_request_time => nil

        plugin.add_hook :before_call do |env|
          start_time = Time.now
        end
      end
    end

    it "takes an event" do
      method_block = Proc.new { |env| start_time = Time.now }
      params = { :type => :before_call, :method_block => method_block, :plugin => 'requests' }
      Nark::Plugin::Event.stub(:new).and_return params
      event = Nark::Plugin::Event.new params
      Nark::Plugin.should_receive(:add_trigger).with(event)

      Nark::Plugin.define :requests do |plugin|
        plugin.add_hook :before_call, &method_block
      end
    end
  end

  describe "#method" do
    it "creates the defined class method" do
      Nark::Plugin.define(:revision) do |plugin|
        plugin.method :foo do
          2
        end
      end
      Nark.foo.should eql "2"
    end
  end

  describe "#variables" do
    it "are accessible" do
      Nark::Plugin.define(:some_plugin) do |plugin|
        plugin.variables :last_request_time => nil
      end
      Nark.should respond_to :last_request_time
    end

    it "can take a hash of variables" do
      Nark::Plugin.define(:some_cool_plugin) do |plugin|
        plugin.variables :msg => 'hey', :value => 2, :hash => {:foo => 'bar'}
      end
      hash = {:foo => 'bar'}
      Nark.hash.should eql hash
      Nark.msg.should eql 'hey'
      Nark.value.should eql 2
    end
  end
end
