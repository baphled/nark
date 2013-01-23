Then /^Nark should have a HTTP reporter setup$/ do
  Nark.reporters.should eql [Nark::Reporter::HTTP]
end
