require 'spec_helper'

describe Rack::Tracker::Plugins::DSL do
  describe "#new" do
    it "allows me to create a new plugin" do
      Rack::Tracker::Plugins::DSL.new :suttin_cool do
      end

      expect {
        Rack::Tracker::Plugins::SuttinCool
      }.to_not raise_error NameError
    end
    it "allows me to define a class method for the plugin"
    it "allows me to add an event hook"
    it "allows me to add plugin variables"
  end
end
