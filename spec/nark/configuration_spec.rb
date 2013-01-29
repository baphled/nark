require 'spec_helper'

describe Nark::Configuration do
  it "stores the defauly plugin path" do
    Nark::Configuration.plugins_paths.should eql 'plugins'
  end

end
