module Nark
  #
  # A basic interface to allow other platforms to easily interact with
  # Nark throw a handful of simple message calls.
  #
  module Interface
    class << self
      #
      # Make a call to Nark
      #
      # Effectively delegates to Nark making sure to only attempt to
      # call public methods.
      #
      # TODO: Refactor so that only the expected methods are accessible
      #
      def call method
        if Nark.respond_to? method.to_sym
          { method.to_sym => Nark.public_send(method) }
        else
          { :error => "Unrecognised message: #{method}" }
        end
      end

      #
      # Returns a list of valid messages to use with call
      #
      # TODO: Would be nice if we didn't have to be so explicit. I'd
      # rather make a single call to get all accessible messages
      #
      # TODO: Review this functionality.
      #
      def messages
        plugin_accessors = Nark::Plugin.defined_methods
        module_acessors = Nark::Plugin::ClassMethods.public_instance_methods
        reporters_accessors = Nark::ReportBroker.singleton_methods.delete_if { |method_name| method_name.to_s.include? '=' }
        { :messages => (plugin_accessors + module_acessors + reporters_accessors).sort}
      end
    end
  end
end
