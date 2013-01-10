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
    When I successfully run `bundle exec nark example help`
    Then the output should contain:
    """
    help        - This output
    example     - Generate an example plugin
    scaffold    - Generate a scaffold plugin
    """

