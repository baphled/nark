require "spec_helper"

describe Nark::CLI do
  include FakeFS::SpecHelpers

  subject { Nark::CLI }

  describe "#help" do
    it "describes how to use list" do
      help_output =
        """
        Usage: nark list plugins

        Lists all example plugins that you can generate.
        """

      expect(subject.help(:list)).to eql(help_output)
    end

    it "describes how to use example" do
      help_output =
        """
        Usage: nark example requests

        Creates an example plugin.
        """

      expect(subject.help(:example)).to eql(help_output)
    end

    it "describes how to use create" do
      help_output =
        """
        Usage: nark create foo

        Creates new plugin template called foo.
        """

      expect(subject.help(:create)).to eql(help_output)
    end

    it "displays the help message by default" do
      help_output =
        """
        Usage: nark help

        Displays this message.
        """

      expect(subject.help).to eql(help_output)
    end

    context "when the option is nil" do
      it "falls back gracefully" do
        help_output =
        """
        Usage: nark help

        Displays this message.
        """

        expect(subject.help(nil)).to eql(help_output)
      end
    end
  end

  describe "#create" do
    it "create a skeleton file in the expected path" do
      subject.create(:foo_bar)

      expect(File).to exist('plugins/foo_bar.rb')
    end

    it "creates the skeleton file with the plugin name" do
      expected = 
"""Nark::Plugin.define :baz_bar do |plugin|
  plugin.description 'Some cool description'

  plugin.method :baz_bar do
    # Do something clever here.
  end
end"""
      subject.create(:baz_bar)

      expect(File.read('plugins/baz_bar.rb')).to eql(expected)
    end

    context "no plugin name provided" do
      it "fails gracefully" do
        expect {
          subject.create nil
        }.to raise_exception(Nark::Exceptions::PluginNameNotDefined)
      end

      it "won't create a plugin with an empty name" do
        expect {
          subject.create ''
        }.to raise_exception(Nark::Exceptions::PluginNameNotDefined)
      end
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
        expect(subject.list(:plugins)).to eql(example_list)
      end

      context "list not found" do
        it "returns an error" do
          expect(subject.list(:foo)).to eql('Invalid list type')
        end
      end
    end
  end

  describe "#examples" do
    context "copying an example" do
      it "allows a user to create an example to the plugins directory" do
        subject.example :requests
        expect(File).to exist('plugins/requests.rb')
      end

      it "can create a requests plugin" do
        expected =
"""Nark::Plugin.define :requests do |plugin|
  plugin.description 'Track the amount of requests made whilst the server is up'

  plugin.variables :total_requests => 0

  plugin.add_hook :before_call do |env|
    plugin.total_requests += 1
  end
end"""
        subject.example :requests
        expect(File.read('plugins/requests.rb')).to eql(expected)
      end

      it "can create a request_times plugin" do
        expected =
"""Nark::Plugin.define :request_times do |plugin|
  plugin.description 'Keeps track of the amount of time each request takes'

  plugin.variables :last_request_time => nil

  plugin.add_hook :before_call do |env|
    plugin.start_time = Time.now
  end

  plugin.add_hook :after_call do |env|
    plugin.last_request_time = (Time.now - @start_time)
  end
end"""
        subject.example :request_times
        expect(File.read('plugins/request_times.rb')).to eql(expected)
      end

      it "can create a revisions plugin" do
        subject.example :revisions
        expect(File.read('plugins/revisions.rb')).not_to be_nil
      end

      it "does not throw an exeception if the plugin template can not be found" do
        expect {
          subject.example :foo
        }.to_not raise_error
      end

      it "displays an error if the plugin is not found" do
        expected = "Invalid plugin name. Try one of the following: requests, request_times, revisions"
        expect(subject.example(:foo)).to eql(expected)
      end
    end
  end

  describe "#plugins" do
    it "returns a list of all included plugins" do
      Nark::Plugin.define :requests do |plugin|
        plugin.description 'Tracks the number of requests made to your application'
      end
      expected = [
        "requests             - Tracks the number of requests made to your application",
      ]
      expect(subject.plugins(:included)).to eql(expected)
    end
    
    it "returns an error message if the given option is not valid" do
      expected = 'Invalid plugins option'
      expect(subject.plugins(:foo)).to eql expected
    end
  end
end
