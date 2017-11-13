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


  context 'accessing plugin variables' do
    before :each do
      Nark::Plugin.define(:some_plugin) do |plugin|
        plugin.variables last_request_time: nil, something_else: 23
      end
    end

    it "has access to the plugin variables" do
      expect(Nark).to respond_to(:last_request_time)
    end

    it 'returns the expected plugin value' do
      expect(subject.something_else).to eql(23)
    end
  end
end
