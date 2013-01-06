Given /^I have installed the plugin$/ do
  # Do nothing here
end

Then /^The requests plugin should be created$/ do
  steps %{
    Then a file named "lib/rack_tracker/plugin/requests.rb" should exist
  }
end

Then /^it should be created in the default location$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the plugins path printed out for the user to add to their application$/ do
  pending # express the regexp above with the code you wish you had
end
