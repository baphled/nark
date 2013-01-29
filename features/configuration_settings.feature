Feature: Configuration settings
  In order to customise Nark
  As a user
  I want to be able to easily configure and setup Nark

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
      config.settings_path = 'spec/fixtures/config/nark.yml'
      config.load_plugins
    end
    """
    Then the plugin path should be set to "spec/fixtures/plugins"
    And 1 plugins should be loaded
