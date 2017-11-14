Feature: Command line interaction
  In order to interact with the application seamlessly between mediums
  As a user
  I want to be able to interact with the tracker via a CLI

  @CLI
  Scenario: I should be informed if I give an invalid command
    Given I have installed the plugin
    When I run `bundle exec nark foo`
    Then the output should contain exactly:
    """

            Usage: nark help

            Displays this message.
            

    """

  @CLI
  Scenario: I should get the help import if the command is invalid
    Given I have installed the plugin
    When I run `bundle exec nark help example`
    Then the output should contain exactly:
    """

            Usage: nark example requests

            Creates an example plugin.
            

    """

  @CLI
  Scenario: I should be able to get a list of plugins
    Given I have installed the plugin
    When I run `bundle exec nark list plugins`
    Then the output should contain exactly:
    """
    requests             - Tracks the number of requests made to your application
    request_times        - Keeps track of the amount of time each request takes
    revisions            - Outputs the git revision

    """

  @CLI
  Scenario: I should be able to get a list of available plugin examples
    Given I have installed the plugin
    When I run `bundle exec nark list foo`
    Then the output should contain "Invalid list type"

  @wip
  Scenario: I should be able to list all the plugins that are currently included
    Given I created the following plugin
    """
      Nark::Plugin.define :requests do |plugin|
        plugin.description 'Tracks the number of requests made to your application'

        plugin.variables :total_requests => 0

        plugin.add_hook :before_call do |env|
          plugin.total_requests += 1
        end
      end
    """
    When I run `bundle exec nark plugins`
    Then the output should contain:
    """
    requests             - Tracks the number of requests made to your application
    """
