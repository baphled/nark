Then /^the internals recognise "(.*?)"$/ do |plugin_name|
  Nark.available_plugins.should include plugin_name
end

Then /^the CLI should recognise "(.*?)"$/ do |plugin_name|
    steps %{
      When I successfully run `bundle exec nark list plugins`
      Then the output should contain "#{plugin_name}"
    }
end
