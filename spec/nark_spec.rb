require "spec_helper"

describe Nark do
  it "can not define where plugins are stored" do
    expect {
      Nark.plugins_paths = 'custom_path'
    }.to raise_error NoMethodError
  end

  context "delegating to Nark::Configuration" do
    it "gives access to the settings path" do
      Nark.should respond_to :settings_path
    end

    it "gives access to the plugins path" do
      Nark.should respond_to :plugins_path
    end
  end
end
