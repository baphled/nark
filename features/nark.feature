Feature: Defining a plugin
  Move code around
  In order to track useful information
  A developer
  I want to be able to easily create a plugin and interact with my plugin

  Scenario: I should be able to create a basic plugin
    Given I have a application I want to track
    When I created the following plugin
    """
      Nark::Plugin.define :requests do |plugin|
      end
    """
    And it should be included

  Scenario: I should be able to define a plugin variable
    Given I have a application I want to track
    When I created the following plugin
    """
      Nark::Plugin.define :requests do |plugin|
        plugin.variables :last_request_time => 'foo'
      end
    """
    Then the "last_request_time" will be accessible via "Nark"

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

  @wip
  Scenario: I should be able to setup a new event hook
    Given I have a application I want to track
    When I created the following plugin
    """
      Nark::Plugin.define :requests do |plugin|
        plugin.variables :last_request_time => nil

        plugin.add_hook :before_call do |env|
          @start_time = Time.now
        end

        plugin.add_hook :after_call do |env|
          Nark.last_request_time = (Time.now - @start_time)
        end
      end
    """
    And I request a page Then the amount of time should be tracked
