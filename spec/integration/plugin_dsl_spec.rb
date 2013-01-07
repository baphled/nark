require "spec_helper"

describe "Plugin DSL" do
  include Rack::Test::Methods

  before :each do
    def app
      @target_app = mock('The target application')
      @target_app.stub(:call).and_return([200, {'PATH_INFO' => '/'}, "Target application"])
      Nark::Middleware.new @target_app
    end
  end

  describe "defining a plugin hook" do
    it "triggers the hook when the application is called" do
      plugin_block = create_plugin(:requests)
      Nark::Plugin.define :something_really_cool, &plugin_block
      get '/'
      Nark.total_requests.should eql 1
    end
  end

  describe "defining a plugin class method" do
    let(:plugin_block) { create_plugin(:revision) }

    it "allows us to define a plugin method" do
      Nark::Plugin.define :something_really_cool, &plugin_block
      Nark.revision.should eql %x[cat .git/refs/heads/master| cut -f 1].chomp
    end
  end

  context "finished defining a plugin" do
    it "should not be storing a plugin name" do
      Nark::Plugin.define :something_really_cool do |plugin|
      end
      expect {
        Nark::Plugin.currently_defining
      }.to raise_error Nark::Exceptions::UnableToTrackPluginBeingDefined
    end
  end
end
