Nark::Plugin.define :revisions do |plugin|
  plugin.method :revision do
    ref_directory = %x[cat .git/HEAD| cut -d ' ' -f 2].chomp
    %x[cat .git/#{ref_directory}].chomp
  end
end
