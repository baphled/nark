Then /^Nark should have a HTTP reporter setup$/ do
  expect(Nark.reporters).to eql([Nark::Reporter::HTTP])
end
