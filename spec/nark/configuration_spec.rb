require 'spec_helper'

describe Nark::Configuration do
  subject { Nark::Configuration }
  it "stores the defauly plugin path" do
    expect(subject.plugins_path).to eql('plugins')
  end

  it "stores the default plugin path" do
    expect(subject.settings_path).to eql('config/nark.yml')
  end

  describe "#configure" do
    it "allows for setting the config path" do
      Nark.settings_path = 'nark.yml'

      expect(Nark.settings_path).to eql('nark.yml')
    end

    context "adding a reporter" do
      it "has access to the reporter object" do
        Nark.configure do |c|
          c.reporters = [:HTTP]
        end

        expect(Nark.reporters).to include(Nark::Reporter::HTTP)
      end
    end
  end

  describe "#settings" do
    it "returns an empty hash if no config file was found" do
      subject.settings_path = ''

      expect(subject.settings).to eql({})
    end

    it "can get the plugins path" do
      config_path = 'spec/fixtures/config/nark.yml'
      subject.settings_path = config_path

      expect(subject.settings).to eql("plugins_path" => "spec/fixtures/plugins")
    end
  end
end
