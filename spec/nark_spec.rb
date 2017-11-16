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

  context 'accessing a plugins accessors and methods' do
    before(:each) do
      Nark::Plugin.define :a_cool_plugin do |plugin|
        plugin.method :revision { 4 + 4 }
        plugin.variables random_number: 23
      end
    end

    it 'should have access to the method' do
      expect(Nark.revision).to eql(8)
    end

    it 'should have access to the variables' do
      expect(Nark.random_number).to eql(23)
    end
  end
end
