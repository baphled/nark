When /^the API is started$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I visit "(.*?)"$/ do |url|
  get url
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
  last_response.body.should eql string.chomp
end
