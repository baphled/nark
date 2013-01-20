Nark::Plugin.define :request_times do |plugin|
  plugin.variables :last_request_time => nil

  plugin.add_hook :before_call do |env|
    @start_time = Time.now
  end

  plugin.add_hook :after_call do |env|
    plugin.last_request_time = (Time.now - @start_time)
  end
end
