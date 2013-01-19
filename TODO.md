TODO
----

 General things that I'd like to see or consider in the project.

 * Integration
   * Automatically include plugins if in default path 
   * Should have a configurable path that plugins can be found in
     * These will be automatically loaded 
   * Improve the examples of using Nark with a service

 * Testing
   * Cover the actual code that is created by the DSL
   * What happens when a user defines a method that accesses a variables they don't own?
    * Probably nothing
   * Make it easier to debug new plugins
     * How much time has it added to requests 
     * How much memory is Nark and/or a plugin taking up?
   * Create cucumber lib to help build and test plugins
     * This can be done by stealing the cuke and rspec tests I run to create my own plugins
     * Should include debugging steps to help with development issue
     * How much time does the plugin add to requests
     * When creating plugins or interfaces.
     * Steps to help output the plugin in ruby format
 
 * Middleware 
   * Detach a plugin from Nark whilst the middle ware is running

 * Reporting engine
   * Allows you to log/store the data retrieved from Nark
     * syslod interface
     * system bus (supports stomp and other common protocols, include TCP/IP)
     * HTTP
     * RPC (though this won't be my primary focus)

 * Usability
   * Can not have duplicate events
   * when trying to create a plugin with the same name as one already included
   * when a plugin variable or method is already in use
   * Let the user know how event hooks are available.

 * Plugins
   * Improve the way descriptions are handled
     * When going down the road of maintain a Nark plugin repository
     descriptions won't be needed as they can be taken from the
     metadata.
   * Improve the way plugins are created. It's quite hacky at the moment.
   * Fix issue with plugin method blocks not executing at the right time
     * they seems to be executing when executing the block within the plugin definition 
   * Have a easy way to include plugins.
     * Would be nice to have a format akin to bundle and librarian-puppet

 * CLI
   * Be able to get a list of currently attached plugins via the CLI
   * Improve the CLI in general, it's very experimental atm.
   * All user to include a plugin via a URL (gists come to mind)
     * This is also a nice way to get others to play with the project and help improve the way it works.
   * Run example application
     * Could then tie this into rake so that I can make sure everything works before releasign a gem
     * This will be useful internally also as it will help to keep the gemspec up to date 

 * Architecture
   * Plugin methods should be attached to a module that is include by Nark
     * This way we can easily find out what methods are plugin based and do cool things with the information
   * Think about making components more pluggable.
     * Would be nice is people to easily pick and mix components to do things not originally conceived of

 * Eating my own dog food
   * Come up with use cases for using Nark
   * Put it through it's paces
