Feature: Expose plugin functionality via HTTP
  In order to provide the user with interesting information over the wire
  As a user of the applications statistics
  I want to be able to make API requests

  @wip @reporting-api
  Scenario: The API service should start along with the middleware
    Given I have a application I want to track
    And I am using the API service
    When I start my application
    Then the API service should be available

  @wip @reporting-api
  Scenario: The root end point lists all resources
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
    When the API is started
    Then I should be able to access "http:://example.com:2309"

  @wip @reporting-api
  Scenario: I should be able to add a plugin and can access to its own method
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
    When the API is started
    Then I should be able to access "http:://example.com:2309/status_codes"

  @wip @reporting-api
  Scenario: The API service does not affect the main application
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
    When the API is started
    And I visit "http://example.com:2309/status_codes"
    Then the "status_codes" should be []
