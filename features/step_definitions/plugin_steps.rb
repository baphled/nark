When /^the last request should store the url$/ do
  expect(Nark.request_times.last[:url]).not_to be_nil
end

When /^the last request should store the total amount of time a request took$/ do
  # TODO: Am sure there's a better way of doing this.
  expect(Nark.request_times.last[:total]).to be_within(0.10).of(0.006000)
end
