module Rack
  module Tracker
    module Macros
      module ClassMethods
        def plugin_variables variable_hashes
          variable_hashes.reduce('') do |s, (variable, value)|
            """
              module Rack::Tracker::Plugins::ACoolPlugin
                module ClassMethods
                  @@#{variable} = #{value}

                  def #{variable}
                    @@#{variable}
                  end

                  protected

                  # FIXME: It's only really need for a way to clear our slate when running specs
                  def #{variable}= value
                    @@#{variable} = value
                  end
                end
              end
            """
          end
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
      end
    end
  end
end
