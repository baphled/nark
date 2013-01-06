Feature: Generating a plugin
  As a developer
  I'd like to be able to generate a sample plugin to get me started

  Scenario: I should be able to generate a "requests" plugin
    Given I have installed the plugin
    When I successfully run `bundle exec rack_tracker example requests`
    Then The "requests" plugin should be created
    And the file "lib/rack_tracker/plugin/requests.rb" should contain exactly:
    """
    Rack::Tracker::Plugin.define :requests do |plugin|
      plugin.variables :total_requests => 0

      plugin.add_hook :before_call do |env|
        plugin.total_requests += 1
      end
    end
    """

  Scenario: I should be able to generate a "request times" plugin
    Given I have installed the plugin
    When I successfully run `bundle exec rack_tracker example request_times`
    Then The "request_times" plugin should be created
    And the file "lib/rack_tracker/plugin/request_times.rb" should contain exactly:
    """
    Rack::Tracker::Plugin.define :requests do |plugin|
      plugin.variables :last_request_time => nil

      plugin.add_hook :before_call do |env|
        @start_time = Time.now
      end

      plugin.add_hook :after_call do |env|
        plugin.last_request_time = (Time.now - @start_time)
      end
    end
    """

  @wip
  Scenario: I should be able to generate a "revisions" plugin
    Given I have installed the plugin
    When I successfully run `bundle exec rack_tracker example revisions`
    Then The "revisions" plugin should be created
    And the file "lib/rack_tracker/plugin/revisions.rb" should contain exactly:
    """
    Rack::Tracker::Plugin.define :requests do |plugin|
      plugin.method :revision do
        %x[cat .git/refs/heads/master| cut -f 1].chomp
      end
    end
    """
