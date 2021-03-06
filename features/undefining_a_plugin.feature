Feature: Undefining a plugin
  In order to cleanly remove a plugin easily
  As a user
  I want to be able to quickly and easily remove a plugin and the added functionality they provide.

  @app-call
  Scenario: I should be able to easily remove a plugin that I have already defined
    Given I have a application I want to track
    When I created the following plugin
    """
    Nark::Plugin.define :status_codes do |plugin|
      plugin.variables :status_codes => []

      plugin.add_hook :after_response do |status_code, header, body, env|
        plugin.status_codes << {:status => status_code, :path => env['PATH_INFO']}
      end
    end
    """
    And I request a page
    Then the "status_codes" will be accessible via "Nark"

    When I undefine the "status_codes" plugin
    Then I should not be able to access "status_codes"
    And there should be no event handlers

  @app-call
  Scenario: Undefining a plugin should not nuke all event handlers
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
    When I created the following plugin
    """
    Nark::Plugin.define :status_codes do |plugin|
      plugin.variables :status_codes => []

      plugin.add_hook :after_response do |status_code, header, body, env|
        plugin.status_codes << {:status => status_code, :path => env['PATH_INFO']}
      end
    end
    """
    Then the "status_codes" will be accessible via "Nark"
    And the "total_requests" will be accessible via "Nark"

    When I undefine the "status_codes" plugin
    And the "total_requests" will be accessible via "Nark"
    Then I should not be able to access "status_codes"
    And there should be 1 event handlers
