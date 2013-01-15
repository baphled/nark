Nark::Plugin.define :revisions do |plugin|
  plugin.description 'Outputs the git revision'

  plugin.method :revision do
    ref_directory = %x[cat .git/HEAD| cut -d ' ' -f 2].chomp
    %x[cat .git/#{ref_directory}].chomp
  end
end
