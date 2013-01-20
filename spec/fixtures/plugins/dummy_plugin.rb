Nark::Plugin.define :dummy_plugin do |plugin|
  plugin.variables :some_value => nil

  plugin.add_hook :before_call do |env|
    @start_time = Time.now
  end
end
