Nark::Plugin.define :revisions do |plugin|
  plugin.method :revision do
    %x[cat .git/refs/heads/master| cut -f 1].chomp
  end
end
