Given /^I have installed the plugin$/ do
  # Do nothing here
end

Then /^The "([^"]*)" plugin should be created$/ do |plugin_name|
  steps %{
    Then a file named "lib/nark/plugin/#{plugin_name}.rb" should exist
  }
end

Then /^it should be created in the default location$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the plugins path printed out for the user to add to their application$/ do
  pending # express the regexp above with the code you wish you had
end
