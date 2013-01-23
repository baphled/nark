require "spec_helper"

describe Nark do
  it "sets event handler for the middleware"

  describe "#configure" do
    it "allows be to add plugin directories" do
      plugin_path = File.join ::File.dirname(__FILE__), 'fixtures/plugins'
      Nark.configure do |c|
        c.plugins_paths = plugin_path
      end
      Nark.plugins_paths.should eql plugin_path
    end

    it "allows to specify which plugins to include"
    it "allows to to add a reporter"
    it "define the plugin destination path"
    it "overrides the event handler for the middleware"

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
