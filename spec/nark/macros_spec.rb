require "spec_helper"

describe Nark::Macros do
  describe "#add_hook" do
    it "adds the hook to the middlewares events" do
      expect(Nark::Plugin.events).to receive(:<<).exactly(:once)

      Nark::Plugin.define :requests do |plugin|
        plugin.variables :last_request_time => nil

        plugin.add_hook :before_call do |env|
          Time.now
        end
      end
    end

    it "takes an event" do
      method_block = Proc.new { |env| Time.now }
      params = { :type => :before_call, :method_block => method_block, :plugin => 'requests' }

      allow(Nark::Event).to receive(:new).and_return(params)
      event = Nark::Event.new params

      expect(Nark::Plugin).to receive(:add_trigger).with(event)

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
      expect(Nark.foo).to eql("2")
    end
  end

  describe "#variables" do
    let(:hash) { {:foo => 'bar'} }

    before :each do
      Nark::Plugin.define(:some_plugin) do |plugin|
        plugin.variables :msg => 'hey', :value => 2, :hash => {:foo => 'bar'}
      end
    end

    after :each do
      Nark::Plugin.undefine(:some_plugin)
    end

    it "are accessible" do
      expect(Nark::Plugin::SomePlugin::PluginMethods).to respond_to(:msg)
    end

    it "can take a hash of variables" do
      expect(Nark::Plugin::SomePlugin::PluginMethods.hash).to eql(hash)
    end
  end

  describe "#description" do
    it "allows a user to set a description for the plugin" do
      Nark::Plugin.define :requests do |plugin|
        plugin.description 'A cool description'
      end

      expect(Nark::Plugin::Requests.metadata).to eql('A cool description')
    end
  end
end
