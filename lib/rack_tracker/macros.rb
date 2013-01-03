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
