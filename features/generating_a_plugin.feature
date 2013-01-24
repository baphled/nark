Feature: Generating a plugin
  As a developer
  I'd like to be able to generate a sample plugin to get me started

  @CLI
  Scenario: I should be able to generate a "requests" plugin
    Given I have installed the plugin
    When I successfully run `bundle exec nark example requests`
    Then The "requests" plugin should be created
    And the file "lib/nark/plugin/requests.rb" should contain exactly:
    """
    Nark::Plugin.define :requests do |plugin|
      plugin.variables :total_requests => 0

      plugin.add_hook :before_call do |env|
        plugin.total_requests += 1
      end
    end
    """

  @CLI
  Scenario: I should be able to generate a "request times" plugin
    Given I have installed the plugin
    When I successfully run `bundle exec nark example request_times`
    Then The "request_times" plugin should be created
    And the file "lib/nark/plugin/request_times.rb" should contain exactly:
    """
    Nark::Plugin.define :request_times do |plugin|
      plugin.variables :last_request_time => nil

      plugin.add_hook :before_call do |env|
        @start_time = Time.now
      end

      plugin.add_hook :after_call do |env|
        plugin.last_request_time = (Time.now - @start_time)
      end
    end
    """

  @CLI
  Scenario: I should be able to generate a "revisions" plugin
    Given I have installed the plugin
    When I successfully run `bundle exec nark example revisions`
    Then The "revisions" plugin should be created
    And the file "lib/nark/plugin/revisions.rb" should contain exactly:
    """
    Nark::Plugin.define :revisions do |plugin|
      plugin.method :revision do
        %x[cat .git/refs/heads/master| cut -f 1].chomp
      end
    end
    """

  @CLI
  Scenario: I should be able to get a list of available plugin examples
    Given I have installed the plugin
    When I successfully run `bundle exec nark list plugins`
    Then the output should contain:
    """
    requests             - Tracks the number of requests made to your application
    request_times        - Keeps track of the amount of time each request takes
    revisions            - Outputs the git revision
    """

  @wip @CLI @announce
  Scenario: The plugin path I supply should be used when create a new plugin
    Given I have installed the plugin
    When I setup Nark with the following
    """
    Nark.configure do |config|
      config.plugin_destination = 'spec/fixtures/plugins'
    end
    """
    And I successfully run `bundle exec nark example revisions`
    Then the "plugin_destination" should be "spec/fixtures/plugins"
    Then a file named "lib/nark/plugin/revisions.rb" should not exist
    Then a file named "spec/fixtures/plugins/revisions.rb" should exist
    And the file "spec/fixtures/plugins/revisions.rb" should contain exactly:
    """
    Nark::Plugin.define :revisions do |plugin|
      plugin.method :revision do
        %x[cat .git/refs/heads/master| cut -f 1].chomp
      end
    end
    """
