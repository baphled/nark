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
  visit '/'
end

Then /^the total requests should be (\d+)$/ do |amount|
  Nark.total_requests.should eql amount.to_i
end

Then /^the "(.*?)" should be$/ do |method, string|
  Nark.send(method.to_sym).should eql eval(string)
end

When /^I setup Nark with the following$/ do |string|
  eval string
end

Then /^the "(.*?)" should be "(.*?)"$/ do |method, value|
  Nark.send(method.to_sym).should eql value
end

Then /^(\d+) plugins should be loaded$/ do |amount|
  Nark.available_plugins.count.should eql amount.to_i
end
