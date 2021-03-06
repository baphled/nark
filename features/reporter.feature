Feature: Nark Reporter
  In order to gather the information Nark is collecting
  As a user of Nark
  I want a simple way to interface with Nark without having to customise the middleware myself

  @reporter
  Scenario: I should be able to select a reporter to use
    Given I setup Nark with the following
    """
    Nark.configure do |config|
      config.load_plugins
      config.reporters = [:HTTP]
    end
    """
    And Nark is setup to monitor my application
    When I visit "/nark/available_plugins"
    Then Nark should have a HTTP reporter setup
    And the response should be
    """
    {
      "plugins": [
        {
          "name": "request_times",
          "description": "Keeps track of the amount of time each request takes"
        },
        {
          "name": "requests",
          "description": "Track the amount of requests made whilst the server is up"
        },
        {
          "name": "revisions",
          "description": "Outputs the git revision"
        },
        {
          "name": "status_report",
          "description": "Fallback description: Use the description macro to define the plugins description"
        }
      ]
    }
    """
