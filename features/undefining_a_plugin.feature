Feature: Undefining a plugin
  In order to cleanly remove a plugin easily
  As a user
  I want to be able to quickly and easily remove a plugin and the added functionality they provide.

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
    Then the "status_codes" should be
    """
    [{:status => 200, :path => '/'}]
    """

    When I undefine the "status_codes" plugin
    Then I should not be able to access "status_codes"
    And there should be no event handlers
