When /^I undefine the "(.*?)" plugin$/ do |plugin|
  Nark::Plugin.undefine plugin.to_sym
end

Then /^I should not be able to access "(.*?)"$/ do |plugin_method|
  Nark.should_not respond_to plugin_method.to_sym
end

Then /^the hook should also be removed$/ do
  Nark::Middleware.events.should be_empty
end
