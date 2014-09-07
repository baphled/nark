Nark::Plugin.define :status_report do |plugin|
  plugin.variables :statuses => []

  plugin.add_hook :after_call do |status_code, header, body, env|
    plugin.statuses << {:status => status_code, :path => env['PATH_INFO']}
  end
end
