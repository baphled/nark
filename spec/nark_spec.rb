require "spec_helper"

describe Nark do
  it "can not define where plugins are stored" do
    expect {
      Nark.plugins_paths = 'custom_path'
    }.to raise_exception(NoMethodError)
  end

  context "delegating to Nark::Configuration" do
    it "gives access to the settings path" do
      expect(Nark).to respond_to(:settings_path)
    end

    it "gives access to the plugins path" do
      expect(Nark).to respond_to(:plugins_path)
    end
  end
end
