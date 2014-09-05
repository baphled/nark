Nark::Plugin.define :requests do |plugin|
  plugin.description 'Track the amount of requests made whilst the server is up'

  plugin.variables :total_requests => 0

  plugin.add_hook :before_call do |env|
    plugin.total_requests += 1
  end
end
