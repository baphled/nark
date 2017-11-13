Feature: Persistence
  In order to keep track of information that Nark collects
  As Nark
  I want to be able to keep the information persistent regardless of interface

  @wip
  Scenario: Active plugins should be consistent across interfaces
    Given I have installed the plugin
    When I run `bundle exec nark foo`
    And I created the following plugin
    """
    Nark::Plugin.define :status_report do |plugin|
      plugin.variables :statues => []

      plugin.add_hook :after_call do |status_code, header, body, env|
        plugin.statues << {:status => status_code, :path => env['PATH_INFO']}
      end
    end
    """
    Then the internals recognise "status_report"
    And the CLI should recognise "status_report"

  @wip @api-call @reporting-api
  Scenario: I should be able to access data collected via the CLI
    Given I have installed the plugin
    When I run `bundle exec nark foo`
    And I created the following plugin
    """
    Nark::Plugin.define :status_report do |plugin|
      plugin.variables :statues => []

      plugin.add_hook :after_call do |status_code, header, body, env|
        plugin.statues << {:status => status_code, :path => env['PATH_INFO']}
      end
    end
    """
    When I request a page
    And I run `bundle exec nark status_report`
    Then the output should contain exactly:
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
