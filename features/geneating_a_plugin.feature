Feature: Generating a plugin
  As a developer
  I'd like to be able to generate a sample plugin to get me started

  @wip
  Scenario: I should be able to generate a requests plugin
    Given I have installed the plugin
    When I run "bundle exec rack_tracker generate plugin requests"
    Then The requests plugin should be created
    And it should be created in the default location
    And the plugins path printed out for the user to add to their application
