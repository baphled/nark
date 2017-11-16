Then /^the internals recognise "(.*?)"$/ do |plugin_name|
  plugin_names = Nark.available_plugins.collect { |plugin| plugin[:name] }

  expect(plugin_names).to include(plugin_name)
end

Then /^the CLI should recognise "(.*?)"$/ do |plugin_name|
    steps %{
      When I run `bundle exec nark list plugins`
      Then the output should contain "#{plugin_name}"
    }
end
