require 'spec_helper'

describe Nark::Configuration do
  it "stores the defauly plugin path" do
    Nark::Configuration.plugins_path.should eql 'plugins'
  end

  describe "#settings" do
    it "from the default path"
    it "from a custom path"
  end
end
