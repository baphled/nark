Given /^I have installed the plugin$/ do
  # Do nothing here
end

Given /^I have a application I want to track$/ do
  # Do nothing here
end

When /^I created the following plugin$/ do |string|
  eval string
end

Then /^The "([^"]*)" plugin should be created$/ do |plugin_name|
  steps %{
    Then a file named "lib/nark/plugin/#{plugin_name}.rb" should exist
  }
end

Then /^it should be included$/ do
  Nark.available_plugins.should eql ["requests"]
end
