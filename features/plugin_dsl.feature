Feature: Plugin DSL
  In order to track useful information on a given application
  As a developer
  I want to be able to easily create a plugin that I can interact

  @plugin-dsl
  Scenario: I should be able to create a basic plugin
    Given I have a application I want to track
    When I created the following plugin
    """
      Nark::Plugin.define :requests do |plugin|
      end
    """
    And it should be included

  @plugin-dsl
  Scenario: I should be able to define a plugin variable
    Given I have a application I want to track
    When I created the following plugin
    """
      Nark::Plugin.define :requests do |plugin|
        plugin.variables :last_request_time => 'foo'
      end
    """
    Then the "last_request_time" will be accessible via "Nark"

  @plugin-dsl
  Scenario: I should be able to define a plugin method
    Given I have a application I want to track
    When I created the following plugin
    """
      Nark::Plugin.define :requests do |plugin|
        plugin.method :revision do
          2 + 2
        end
      end
    """
    Then the "revision" will be accessible via "Nark"
    And the "revision" should be 4
