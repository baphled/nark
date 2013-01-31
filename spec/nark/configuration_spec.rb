require 'spec_helper'

describe Nark::Configuration do
  it "stores the defauly plugin path" do
    Nark::Configuration.plugins_path.should eql 'plugins'
  end

  it "stores the default plugin path" do
    Nark::Configuration.settings_path.should eql 'config/nark.yml'
  end

  describe "#configure" do
    it "allows for setting the config path" do
      Nark.settings_path = 'nark.yml'
      Nark.settings_path.should eql 'nark.yml'
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

  describe "#settings" do
    it "returns an empty hash if no config file was found" do
      Nark::Configuration.settings_path = ''
      Nark::Configuration.settings.should == {}
    end

    it "can get the plugins path" do
      config_path = 'spec/fixtures/config/nark.yml'
      Nark::Configuration.settings_path = config_path
      Nark::Configuration.settings.should eql "plugins_path" => "spec/fixtures/plugins"
    end
  end
end
