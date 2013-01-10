Feature: Command line interaction
  In order to interact with the application seamlessly between mediums
  As a user
  I want to be able to interact with the tracker via a CLI

  Scenario: I should be informed if I give an invalid command
    Given I have installed the plugin
    When I successfully run `bundle exec nark foo`
    Then the output should contain:
    """Usage: nark help

    Displays this message."""

  @wip
  Scenario: I should get the help import if the command is invalid
    Given I have installed the plugin
    When I successfully run `bundle exec nark help example`
    Then the output should contain:
    """
    Usage: nark example requests

    Creates an example plugin.
    """

  Scenario: I should be able to get a list of plugins
    Given I have installed the plugin
    When I successfully run `bundle exec nark list plugins`
    Then the output should contain:
    """
    requests             - Tracks the number of requests made to your application
    request_times        - Keeps track of the amount of time each request takes
    revisions            - Outputs the git revision
    """

