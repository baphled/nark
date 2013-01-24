Feature: Expose plugin functionality via HTTP
  In order to provide the user with interesting information over the wire
  As a user of the applications statistics
  I want to be able to make API requests

  @http-reporter @reporting-api
  Scenario: Should be able to able to find out what plugins are setup
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
    When I visit "/nark/available_plugins"
    Then the response should be
    """
    {
      "plugins": [
        "status_codes"
      ]
    }
    """

  @http-reporter @reporting-api
  Scenario: Should be able to able to access a plugin variable via the reporter
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
    When I visit "/"
    When I visit "/nark/status_codes"
    Then the endpoint will be available

  @reporting-api
  Scenario: An endpoint will not be exposed if it is not added via a plugin
    Given I have a application I want to track
    When I visit "/nark/status_codes"
    Then the endpoint will not be available

  @reporting-api
  Scenario: Endpoints are dynamically created
    Given I have a application I want to track
    When I created the following plugin
    """
    Nark::Plugin.define :tracker do |plugin|
      plugin.variables :tracker => []

      plugin.add_hook :after_call do |status_code, header, body, env|
        plugin.tracker << {:status => status_code, :path => env['PATH_INFO']}
      end
    end
    """
    When I visit "/"
    And I visit "/nark/tracker"
    Then the response should be
    """
    {
      "tracker": [
        {
          "status": 200,
          "path": "/"
        }
      ]
    }
    """

  @reporting-api
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
    Then I visit "/nark"
    And the response should be
    """
    {
      "endpoints": [
        {
          "url": "/nark/status_codes",
          "rel": "plugin_method"
        },
        {
          "url": "/nark",
          "rel": "self"
        }
      ]
    }
    """

  @reporting-api
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
    And I visit "/nark/status_codes"
    And the response should not be
    """
    {
      "status_codes": []
    }
    """

  @reporting-api @http-reporter
  Scenario: Can return all of the plugin information in one go
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
    And I created the following plugin
    """
    Nark::Plugin.define :requests do |plugin|
      plugin.variables :total_requests => 0

      plugin.add_hook :before_call do |env|
        plugin.total_requests += 1
      end
    end
    """
    And I visit "/nark/plugin/stats"
    Then the response should be
    """
    {
      "stats": [
        {
          "status_codes": [
  
          ]
        },
        {
          "total_requests": 0
        }
      ]
    }
    """

  @reporting-api @http-reporter
  Scenario: I expect more than one plugin to work together
    Given I have a application I want to track
    And I created the following plugin
    """
    Nark::Plugin.define :status_codes do |plugin|
      plugin.variables :status_codes => []

      plugin.add_hook :after_call do |status_code, header, body, env|
        plugin.status_codes << {:status => status_code, :path => env['PATH_INFO']}
      end
    end
    """
    And I created the following plugin
    """
    Nark::Plugin.define :requests do |plugin|
      plugin.variables :total_requests => 0

      plugin.add_hook :before_call do |env|
        plugin.total_requests += 1
      end
    end
    """
    When I request a page
    And I visit "/nark/plugin/stats"
    Then the response should be
    """
    {
      "stats": [
        {
          "status_codes": [
            {
              "status": 200,
              "path": "/"
            }
          ]
        },
        {
          "total_requests": 1
        }
      ]
    }
    """

  @wip @http-reporter  @reporting-api
  Scenario: Nark should not collect information from the HTTP reporter included
