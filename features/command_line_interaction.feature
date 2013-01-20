Feature: Command line interaction
  In order to interact with the application seamlessly between mediums
  As a user
  I want to be able to interact with the tracker via a CLI

  @CLI
  Scenario: I should be informed if I give an invalid command
    Given I have installed the plugin
    When I successfully run `bundle exec nark foo`
    Then the output should contain exactly:
    """

            Usage: nark help

            Displays this message.
            

    """

  @CLI
  Scenario: I should get the help import if the command is invalid
    Given I have installed the plugin
    When I successfully run `bundle exec nark help example`
    Then the output should contain exactly:
    """

            Usage: nark example requests

            Creates an example plugin.
            

    """

  @CLI
  Scenario: I should be able to get a list of plugins
    Given I have installed the plugin
    When I successfully run `bundle exec nark list plugins`
    Then the output should contain exactly:
    """
    requests             - Tracks the number of requests made to your application
    request_times        - Keeps track of the amount of time each request takes
    revisions            - Outputs the git revision

    """

  @wip @CLI @configuration
  Scenario: The plugin path I supply should be used when create a new plugin
    Given I have installed the plugin
    When I setup Nark with the following
    """
    Nark.configure do |config|
      config.plugins_paths = 'spec/fixtures/plugins'
    end
    """
    And I successfully run `bundle exec nark example revisions`
    Then the "plugins_paths" should be "spec/fixtures/plugins"
    Then a file named "spec/fixtures/plugins/revisions.rb" should exist
    And the file "spec/fixtures/plugins/revisions.rb" should contain exactly:
    """
    Nark::Plugin.define :revisions do |plugin|
      plugin.method :revision do
        %x[cat .git/refs/heads/master| cut -f 1].chomp
      end
    end
    """
