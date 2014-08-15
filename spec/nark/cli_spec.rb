require "spec_helper"

describe Nark::CLI do
  include FakeFS::SpecHelpers

  describe "#help" do
    it "describes how to use list" do
      help_output =
        """
        Usage: nark list plugins

        Lists all example plugins that you can generate.
        """
        Nark::CLI.help(:list).should eql help_output
    end

    it "describes how to use example" do
      help_output =
        """
        Usage: nark example requests

        Creates an example plugin.
        """
        Nark::CLI.help(:example).should eql help_output
    end

    it "describes how to use create" do
      help_output =
        """
        Usage: nark create foo

        Creates new plugin template called foo.
        """
        Nark::CLI.help(:create).should eql help_output
    end

    it "displays the help message by default" do
      help_output =
        """
        Usage: nark help

        Displays this message.
        """
        Nark::CLI.help.should eql help_output
    end
  end

  describe "#create" do
    it "create a skeleton file in the expected path" do
      Nark::CLI.create(:foo_bar)
      File.should exist 'plugins/foo_bar.rb'
    end

    it "creates the skeleton file with the plugin name" do
      expected = 
"""Nark::Plugin.define :baz_bar do |plugin|
  plugin.method :baz_bar do
    # Do something clever here.
  end
end"""
      Nark::CLI.create :baz_bar
      File.read('plugins/baz_bar.rb').should eql expected
    end
  end

  describe "#list" do
    context "listing examples" do
      it "lists all the example plugins available" do
        example_list = [
          "requests             - Tracks the number of requests made to your application",
          "request_times        - Keeps track of the amount of time each request takes",
          "revisions            - Outputs the git revision"
        ]
        Nark::CLI.list(:plugins).should eql example_list
      end

      context "list not found" do
        it "returns an error" do
          Nark::CLI.list(:foo).should eql 'Invalid list type'
        end
      end
    end
  end

  describe "#examples" do
    context "copying an example" do
      it "allows a user to create an example to the plugins directory" do
        Nark::CLI.example :requests
        File.should exist 'plugins/requests.rb'
      end

      it "can create a requests plugin" do
        expected =
"""Nark::Plugin.define :requests do |plugin|
  plugin.variables :total_requests => 0

  plugin.add_hook :before_call do |env|
    plugin.total_requests += 1
  end
end"""
        Nark::CLI.example :requests
        File.read('plugins/requests.rb').should eql expected
      end

      it "can create a request_times plugin" do
        expected =
"""Nark::Plugin.define :request_times do |plugin|
  plugin.variables :last_request_time => nil

  plugin.add_hook :before_call do |env|
    plugin.start_time = Time.now
  end

  plugin.add_hook :after_call do |env|
    plugin.last_request_time = (Time.now - @start_time)
  end
end"""
        Nark::CLI.example :request_times
        File.read('plugins/request_times.rb').should eql expected
      end

      it "can create a revisions plugin" do
        expected =
"""Nark::Plugin.define :revisions do |plugin|
  plugin.method :revision do
    %x[cat .git/refs/heads/master| cut -f 1].chomp
  end
end"""
        Nark::CLI.example :revisions
        File.read('plugins/revisions.rb').should eql expected
      end

      it "does not throw an exeception if the plugin template can not be found" do
        expect {
          Nark::CLI.example :foo
        }.to_not raise_error Errno
      end

      it "displays an error if the plugin is not found" do
        expected = "Invalid plugin name. Try one of the following: requests, request_times, revisions"
        Nark::CLI.example(:foo).should eql expected
      end
    end
  end
end
