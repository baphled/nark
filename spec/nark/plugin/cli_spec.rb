require "spec_helper"

describe Nark::Cli do
  include FakeFS::SpecHelpers
  module CliWrapper
    include Nark::Cli
  end

  describe "#help" do
    it "describes how to use list" do
      help_output =
        """
        Usage: nark list plugins

        Lists all example plugins that you can generate.
        """
        CliWrapper.help(:list).should eql help_output
    end

    it "describes how to use example" do
      help_output =
        """
        Usage: nark example requests

        Creates an example plugin.
        """
        CliWrapper.help(:example).should eql help_output
    end

    it "describes how to use create" do
      pending "Yet to implement actual functionality for this"
      help_output =
        """
        Usage: nark create foo

        Creates new plugin template called foo.
        """
        CliWrapper.help(:example).should eql help_output
    end

    it "displays the help message by default" do
      help_output =
        """
        Usage: nark help

        Displays this message.
        """
        CliWrapper.help.should eql help_output
    end
  end

  describe "#create" do
    it "takes a plugin name"
    it "optionally takes a plugin path"
    it "create a skeleton file in the expected path"
    it "creates the skeleton file with the plugin name"
  end

  describe "#list" do
    context "listing examples" do
      it "lists all the example plugins available" do
        example_list = [
          "requests             - Tracks the number of requests made to your application",
          "request_times        - Keeps track of the amount of time each request takes",
          "revisions            - Outputs the git revision"
        ]
        CliWrapper.list(:plugins).should eql example_list
      end

      context "list not found" do
        it "returns an error" do
          CliWrapper.list(:foo).should eql 'Invalid list type'
        end
      end
    end
  end

  describe "#examples" do
    context "copying an example" do
      it "allows a user to create an example to the plugins directory" do
        CliWrapper.example :requests
        File.should exist 'lib/nark/plugin/requests.rb'
      end

      it "can create a requests plugin" do
        expected =
"""Nark::Plugin.define :requests do |plugin|
  plugin.variables :total_requests => 0

  plugin.add_hook :before_call do |env|
    plugin.total_requests += 1
  end
end"""
        CliWrapper.example :requests
        File.read('lib/nark/plugin/requests.rb').should include expected
      end

      it "can create a request_times plugin" do
        expected =
"""Nark::Plugin.define :requests do |plugin|
  plugin.variables :last_request_time => nil

  plugin.add_hook :before_call do |env|
    @start_time = Time.now
  end

  plugin.add_hook :after_call do |env|
    plugin.last_request_time = (Time.now - @start_time)
  end
end"""
        CliWrapper.example :request_times
        File.read('lib/nark/plugin/request_times.rb').should include expected
      end

      it "can create a revisions plugin" do
        expected =
"""Nark::Plugin.define :revisions do |plugin|
  plugin.method :revision do
    %x[cat .git/refs/heads/master| cut -f 1].chomp
  end
end"""
        CliWrapper.example :revisions
        File.read('lib/nark/plugin/revisions.rb').should include expected
      end
    end
  end
end
