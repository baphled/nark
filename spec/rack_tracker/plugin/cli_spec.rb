require "spec_helper"

describe Rack::Tracker::Cli do
  include FakeFS::SpecHelpers
  module CliWrapper
    include Rack::Tracker::Cli
  end

  describe "#examples" do
    context "listing examples" do
      it "lists all the example plugins available"
    end

    context "copying an example" do
      it "allows a user to create an example to the plugins directory" do
        CliWrapper.example :requests
        File.should exist 'lib/rack_tracker/plugin/requests.rb'
      end

      it "can create a requests plugin" do
        expected =
"""Rack::Tracker::Plugin.define :requests do |plugin|
  plugin.variables :total_requests => 0

  plugin.add_hook :before_call do |env|
    plugin.total_requests += 1
  end
end"""
        CliWrapper.example :requests
        File.read('lib/rack_tracker/plugin/requests.rb').should include expected
      end

      it "can create a request_times plugin" do
        expected =
"""Rack::Tracker::Plugin.define :requests do |plugin|
  plugin.variables :last_request_time => nil

  plugin.add_hook :before_call do |env|
    @start_time = Time.now
  end

  plugin.add_hook :after_call do |env|
    plugin.last_request_time = (Time.now - @start_time)
  end
end"""
        CliWrapper.example :request_times
        File.read('lib/rack_tracker/plugin/request_times.rb').should include expected
      end
    end
  end
end
