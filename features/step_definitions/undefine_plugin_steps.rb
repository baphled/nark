When /^I undefine the "(.*?)" plugin$/ do |plugin|
  Nark::Plugin.undefine plugin.to_sym
end

Then /^I should not be able to access "(.*?)"$/ do |plugin_method|
  Nark.should_not respond_to plugin_method.to_sym
end

Then /^there should be no event handlers$/ do
  Nark::EventHandler.events.should be_empty
end

Then /^there should be (\d+) event handlers$/ do |amount|
  Nark::EventHandler.events.count.should eql amount.to_i
end
