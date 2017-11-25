Nark::Plugin.define :revisions do |plugin|
  plugin.description 'Outputs the git revision'

  plugin.method :revision do
    %x[cat .git/HEAD| cut -d ' ' -f 2].chomp
  end
end
