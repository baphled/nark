require "spec_helper"

describe Rack::Tracker do
  it "requires all default plugins" do
    Rack::Tracker.new stub(:app, :call => 'foo')
    Rack::Tracker.available_plugins.should eql ['request_times', 'requests']
  end

  context "configure what I track" do
    it "my plugins path"
    it "stores the plugins I want to use"
  end
end
