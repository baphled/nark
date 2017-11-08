require "spec_helper"

describe Nark::Macros do
  describe "#add_hook" do
    it "adds the hook to the middlewares events" do
      expect(Nark::Plugin.events).to receive(:<<).exactly(:once)

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
    it "are accessible" do
      Nark::Plugin.define(:some_plugin) do |plugin|
        plugin.variables :last_request_time => nil
      end

      expect(Nark).to respond_to(:last_request_time)
    end

    it "can take a hash of variables" do
      Nark::Plugin.define(:some_cool_plugin) do |plugin|
        plugin.variables :msg => 'hey', :value => 2, :hash => {:foo => 'bar'}
      end
      hash = {:foo => 'bar'}
      expect(Nark.hash).to eql(hash)
      expect(Nark.msg).to eql('hey')
      expect(Nark.value).to eql(2)
    end
  end

  describe "#description" do
    it "allows a user to set a description for the plugin" do
      Nark::Plugin.define :requests do |plugin|
        plugin.description 'A cool description'
      end

      expect(Nark::Plugin::Requests.metadata).to eql('A cool description')
      expect(Nark.available_plugins).to include(:name => 'requests', :description => 'A cool description')
    end
  end
end
