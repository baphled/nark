Feature: Nark Middleware
  In order to intercept information on
  As the middleware
  I want to be able to intercept requests and responses

  @middleware @plugin-dsl
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

  @middleware @plugin-dsl
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

  @wip @plugin
  Scenario: There should be a way to reset the plugin path
