require 'spec_helper'

describe Nark::Configuration do
  it "stores the defauly plugin path" do
    Nark::Configuration.plugins_path.should eql 'plugins'
  end

  it "stores the default plugin path" do
    Nark::Configuration.settings_path.should eql 'config/nark.yml'
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
