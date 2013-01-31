require "spec_helper"

describe Nark do
  it "sets event handler for the middleware"

  context "delegating to Nark::Configuration" do
    it "gives access to the settings path" do
      Nark.should respond_to :settings_path
    end

    it "gives access to the plugin destination" do
      Nark.should respond_to :plugin_destination
    end

    it "gives access to the plugins path" do
      Nark.should respond_to :plugins_path
    end
  end

  describe "#configure" do
    it "allows for setting the config path" do
      Nark.settings_path = 'nark.yml'
      Nark.settings_path.should eql 'nark.yml'
    end

    it "can not define where plugins are stored" do
      expect {
        Nark.plugins_paths = 'custom_path'
      }.to raise_error NoMethodError
    end

    context "adding a reporter" do
      it "has access to the reporter object" do
        Nark.configure do |c|
          c.reporters = [:HTTP]
        end
        Nark.reporters.should include Nark::Reporter::HTTP
      end
    end
  end
end
