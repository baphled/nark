Feature: Generating a plugin
  As a developer
  I'd like to be able to generate a sample plugin to get me started

  @CLI
  Scenario: I should be able to generate a "requests" plugin
    Given I have installed the plugin
    When I run `bundle exec nark example requests`
    Then The "requests" plugin should be created
    And the file "plugins/requests.rb" should contain exactly:
    """
    Nark::Plugin.define :requests do |plugin|
      plugin.description 'Track the amount of requests made whilst the server is up'

      plugin.variables :total_requests => 0

      plugin.add_hook :before_call do |env|
        plugin.total_requests += 1
      end
    end
    """

  @CLI
  Scenario: I should be able to generate a "request times" plugin
    Given I have installed the plugin
    When I run `bundle exec nark example request_times`
    Then The "request_times" plugin should be created
    And the file "plugins/request_times.rb" should contain exactly:
    """
    Nark::Plugin.define :request_times do |plugin|
      plugin.description 'Keeps track of the amount of time each request takes'

      plugin.variables :last_request_time => nil

      plugin.add_hook :before_call do |env|
        plugin.start_time = Time.now
      end

      plugin.add_hook :after_call do |env|
        plugin.last_request_time = (Time.now - @start_time)
      end
    end
    """

  @CLI
  Scenario: I should be able to generate a "revisions" plugin
    Given I have installed the plugin
    When I run `bundle exec nark example revisions`
    Then The "revisions" plugin should be created
    And the file "plugins/revisions.rb" should contain exactly:
    """
    Nark::Plugin.define :revisions do |plugin|
      plugin.description 'Outputs the git revision'

      plugin.method :revision do
        %x[cat .git/HEAD| cut -d ' ' -f 2].chomp
      end
    end
    """

  @CLI
  Scenario: I should be able to get a list of available plugin examples
    Given I have installed the plugin
    When I run `bundle exec nark list plugins`
    Then the output should contain:
    """
    requests             - Tracks the number of requests made to your application
    request_times        - Keeps track of the amount of time each request takes
    revisions            - Outputs the git revision
    """

  @CLI
  Scenario: The plugin path I supply should be used when create a new plugin
    Given I have installed the plugin
    And I write to "config/nark.yml" with:
    """
    plugins_path: 'nark/plugins'
    """
    When I run `bundle exec nark example revisions`
    Then a file named "lib/nark/plugin/revisions.rb" should not exist
    Then a file named "nark/plugins/revisions.rb" should exist
    And the file "nark/plugins/revisions.rb" should contain exactly:
    """
    Nark::Plugin.define :revisions do |plugin|
      plugin.description 'Outputs the git revision'

      plugin.method :revision do
        %x[cat .git/HEAD| cut -d ' ' -f 2].chomp
      end
    end
    """
    When I run `bundle exec nark list foo`
    Then the output should contain "Invalid list type"

  Scenario: I should be able to get a list of available plugins
    Given I have installed the plugin
    When I created the following plugin
    """
      Nark::Plugin.define :random do |plugin|
        plugin.description 'A basic description'
        plugin.method :revision do
          2 + 2
        end
      end
    """
    When I run `bundle exec nark list plugins`
    Then the "available_plugins" should be
    """
    [{:name => 'random', :description => 'A basic description'}]
    """
