module PluginMacro
  module ExampleMethods

    def create_plugin plugin_name
      case plugin_name.to_sym
      when :revision
        Proc.new do |plugin|
          plugin.method :revision do
            %x[cat .git/refs/heads/master| cut -f 1].chomp
          end
        end
      when :request_times
        Proc.new do |plugin|
          plugin.variables :last_request_time => nil

          plugin.add_hook :before_call do |env|
            @start_time = Time.now
          end

          plugin.add_hook :after_call do |env|
            Rack::Tracker.last_request_time = (Time.now - @start_time)
          end
        end
      when :requests
        Proc.new do |plugin|
          plugin.variables :total_requests => 0

          plugin.add_hook :before_call do |env|
            Rack::Tracker.total_requests += 1
          end
        end
      end
    end
  end

  def self.included(receiver)
    receiver.send :include, ExampleMethods
  end
end
