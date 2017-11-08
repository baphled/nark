require "spec_helper"

describe "Plugin DSL" do
  include Rack::Test::Methods

  let(:target_app) { double('The target application') }

  before :each do
    def app
      allow(target_app).to receive(:call).and_return([200, {'PATH_INFO' => '/'}, "Target application"])

      Nark::Middleware.new(target_app)
    end
  end

  describe "defining a plugin hook" do
    let(:plugin_block) { create_plugin(:requests) }

    it "triggers the hook when the application is called" do
      Nark::Plugin.define(:something_really_cool, &plugin_block)

      get '/'

      expect(Nark.total_requests).to eql(1)
    end
  end

  describe "defining a plugin class method" do
    let(:plugin_block) { create_plugin(:revision) }

    it "allows us to define a plugin method" do
      Nark::Plugin.define(:something_really_cool, &plugin_block)

      expect(Nark.revision).to eql('2')
    end
  end

  context "finished defining a plugin" do
    it "should not be storing a plugin name" do
      Nark::Plugin.define :something_really_cool do |plugin|
      end

      expect {
        Nark::Plugin.currently_defining
      }.to raise_exception(Nark::Exceptions::UnableToTrackPluginBeingDefined)
    end
  end
end
