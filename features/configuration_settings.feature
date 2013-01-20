Feature: Configuration settings
  In order to customise Nark
  As a user
  I want to be able to easily configure and setup Nark

  @configuration
  Scenario: I should be able to set the default plugin path
    Given I have installed the plugin
    When I setup Nark with the following
    """
    Nark.configure do |config|
      config.plugins_paths = 'fixtures/plugins'
    end
    """
    Then the "plugins_paths" should be "fixtures/plugins"

  @configuration
  Scenario: I should be able to configure whether plugins should be loaded when the middleware is started
    Given I have installed the plugin
    When I setup Nark with the following
    """
    Nark.configure do |config|
      config.load_plugins
    end
    """
    Then 4 plugins should be loaded

  @configuration
  Scenario: I should autoload plugins from the custom path
    Given I have installed the plugin
    When I setup Nark with the following
    """
    Nark.configure do |config|
      config.plugins_paths = 'spec/fixtures/plugins'
      config.load_plugins
    end
    """
    Then 1 plugins should be loaded

  @wip @configuration @CLI
  Scenario: The plugin path I supply should be used when create a new plugin
    Given I have installed the plugin
    When I setup Nark with the following
    """
    Nark.configure do |config|
      config.plugins_paths = 'spec/fixtures/plugins'
    end
    """
    And I successfully run `bundle exec nark example revisions`
    Then the "plugins_paths" should be "spec/fixtures/plugins"
    Then a file named "spec/fixtures/plugins/revisions.rb" should exist
    And the file "spec/fixtures/plugins/revisions.rb" should contain exactly:
    """
    Nark::Plugin.define :revisions do |plugin|
      plugin.method :revision do
        %x[cat .git/refs/heads/master| cut -f 1].chomp
      end
    end
    """
