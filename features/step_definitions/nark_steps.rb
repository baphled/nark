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

Then /^the "(.*?)" will be accessible via "(.*?)"$/ do |method, module_name|
  module_name.constantize.should respond_to method.to_sym
end

Then /^the "(.*?)" should be (\d+)$/ do |method, value|
  Nark.send(method.to_sym).should eql value
end

When /^I request a page$/ do
  get '/'
end

Then /^the amount of time should be tracked$/ do
  Nark.total_requests.should eql 1
end
