Given /^I have installed the plugin$/ do
  # Do nothing here
end

Given /^Nark is setup to monitor my application$/ do
  Capybara.app = Nark::Middleware.with(DummyApp)
end

Given /^I have a application I want to track$/ do
  # Do nothing here
end

When /^I created the following plugin$/ do |string|
  eval string
end

Then /^The "([^"]*)" plugin should be created$/ do |plugin_name|
  steps %{
    Then a file named "plugins/#{plugin_name}.rb" should exist
  }
end

Then /^it should be included$/ do
  params = {
    :name=>"requests",
    :description=>"Fallback description: Use the description macro to define the plugins description"
  }

  expect(Nark.available_plugins).to include(params)
end

Then /^the "(.*?)" will be accessible via "(.*?)"$/ do |method, module_name|
  expect(module_name.constantize).to respond_to(method.to_sym)
end

Then /^the "(.*?)" should be (\d+)$/ do |method, value|
  expect(Nark.send(method.to_sym)).to eql(value)
end

When /^I request a page$/ do
  visit '/'
end

Then /^the total requests should be (\d+)$/ do |amount|
  expect(Nark.total_requests).to eql(amount.to_i)
end

Then /^the "(.*?)" should be$/ do |method, string|
  expect(Nark.send(method.to_sym)).to eql(eval(string))
end

When /^I setup Nark with the following$/ do |string|
  eval string
end

Then /^the "(.*?)" should be "(.*?)"$/ do |method, value|
  expect(Nark.send(method.to_sym)).to eql value
end

Then /^(\d+) plugins should be loaded$/ do |amount|
  expect(Nark.available_plugins.count).to eql(amount.to_i)
end

Then /^the plugin path should be set to "(.*?)"$/ do |value|
  expect(Nark::Configuration.plugins_path).to eql(value)
end

