When /^I undefine the "(.*?)" plugin$/ do |plugin|
  Nark::Plugin.undefine plugin.to_sym
end

Then /^I should not be able to access "(.*?)"$/ do |plugin_method|
  expect(Nark).not_to respond_to(plugin_method.to_sym)
end

Then /^there should be no event handlers$/ do
  expect(Nark::Plugin.events).to be_empty
end

Then /^there should be (\d+) event handlers$/ do |amount|
  expect(Nark::Plugin.events.count).to eql(amount.to_i)
end
