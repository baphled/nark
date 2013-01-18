Nark::Plugin.define :status_report do |plugin|
  plugin.description 'Tracks each request and its responding status code'

  plugin.variables :statues => []

  plugin.add_hook :after_response do |status_code, header, body, env|
    plugin.statues << {:status => status_code, :path => env['PATH_INFO']}
  end
end
