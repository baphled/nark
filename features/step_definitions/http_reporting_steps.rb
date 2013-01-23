When /^the API is started$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I visit "(.*?)"$/ do |url|
  visit url
end

Then /^the "(.*?)" should be \[\]$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^the API service should be available$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I should be able to access "(.*?)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^the response should be$/ do |string|
  page.source.should eql string.chomp
end

Then /^the response should not be$/ do |string|
  page.source.should_not eql string.chomp
end

Then /^the endpoint will not be available$/ do
  page.status_code.should eql 404
end

Then /^the endpoint will be available$/ do
  page.status_code.should eql 200
end
