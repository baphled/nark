Feature: Request times plugin
  In order to have a plugin to play around with
  As user
  I want to be able to collect the amount of time it is taking to make a given request

  @wip @plugin
  Scenario: I should be able to define a plugin that tracks the request times for each request
    Given I have a application I want to track
    And I created the following plugin
    """
      Nark::Plugin.define :request_times do |plugin|
        plugin.variables :last_request_time => nil
        plugin.variables :request_times => []

        plugin.add_hook :before_call do |env|
          @start_time = Time.now
        end

        plugin.add_hook :after_call do |status, header, body, env|
          plugin.request_times << { url: env['PATH_INFO'], total: (Time.now - @start_time) }
          plugin.last_request_time = (Time.now - @start_time)
        end
      end
    """
    When I request a page
    And the last request should store the url
    And the last request should store the total amount of time a request took
