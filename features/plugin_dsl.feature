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
          '4'
        end
      end
    """
    Then the "revision" will be accessible via "Nark"
    And the "revision" should be "4"

  @webapp
  Scenario: I should be able to setup a new event hook
    Given I have a application I want to track
    When I created the following plugin
    """
      Nark::Plugin.define :requests do |plugin|
        plugin.variables :total_requests => 0

        plugin.add_hook :before_call do |env|
          plugin.total_requests += 1
        end
      end
    """
    And I request a page
    Then the total requests should be 1

  @webapp
  Scenario: I should be able to intercept response
    Given I have a application I want to track
    When I created the following plugin
    """
    Nark::Plugin.define :status_codes do |plugin|
      plugin.variables :status_codes => []

      plugin.add_hook :after_call do |status_code, header, body, env|
        plugin.status_codes << {:status => status_code, :path => env['PATH_INFO']}
      end
    end
    """
    And I request a page
    Then the "status_codes" should be
    """
    [{:status => 200, :path => '/'}]
    """

  Scenario: Should be able to set a description for a plugin
    Given I have a application I want to track
    When I created the following plugin
    """
      Nark::Plugin.define :random do |plugin|
        plugin.description 'A basic description'
        plugin.method :revision do
          2 + 2
        end
      end
    """
