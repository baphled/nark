Feature: Generating a plugin
  As a developer
  I'd like to be able to generate a sample plugin to get me started

  @wip
  Scenario: I should be able to generate a requests plugin
    Given I have installed the plugin
    When I successfully run `bundle exec rack_tracker example requests`
    Then The requests plugin should be created
    And the file "lib/rack_tracker/plugin/requests.rb" contain exactly:
    """
      Rack::Tracker::Plugin.define :requests do |plugin|
        plugin.variables :total_requests => 0

        plugin.add_hook :before_call do |env|
          plugin.total_requests += 1
        end
      end
    """
