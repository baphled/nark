[[TODO]]
----

 General things that I'd like to see or consider in the project.

 * Integration
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
     * This can be done by stealing the cucumber and rspec tests I run to create my own plugins
     * Should include debugging steps to help with development issue
     * How much time does the plugin add to requests
     * When creating plugins or interfaces.
     * Steps to help output the plugin in ruby format
 
 * Middleware 
   * Detach a plugin from Nark whilst the middle ware is running

 * Reporting engine
   * Allows you to log/store the data retrieved from Nark
     * statd
     * Syslog interface
     * System Bus (supports stomp and other common protocols, include TCP/IP)
     * Socket
     * HTTP
     * RPC (though this won't be my primary focus)

 * Usability
   * When trying to create a plugin with the same name as one already included
   * When a plugin variable or method is already in use
   * Let the user know how event hooks are available.

 * Plugins
   * Improve the way descriptions are handled
     * When going down the road of maintaining a Nark plugin repository
     descriptions won't be needed as they can be taken from the metadata.
   * Improve the way plugins are created. It's quite hacky at the moment.
   * Can reuse Cucumber and Rspec helpers so to help other developer plugins
   * Users should be able to define where plugins get created
     * For the moment this will be done via the configuration settings.
     * Later this will also be possible via the CLI.
   * Fix issue with plugin method blocks not executing at the right time
     * They seems to be executing when executing the block within the plugin definition 
   * Have a easy way to include plugins.
     * Would be nice to have a format akin to bundle and librarian-puppet
   * Be able to list all plugins
   * Prove a way to send tracked data to a datastore
     * The datastore could be anything from a DB of some sort to a server/daemon that waits listens for these messages
   * Dynamically add plugins at runtime

 * CLI
   * Be able to get a list of currently attached plugins via the CLI
   * Improve the CLI in general, it's very experimental ATM.
   * Allow users to include a plugin via a URL (gists come to mind)
     * This is also a nice way to get others to play with the project and help improve the way it works.
   * Run example application
     * Could then tie this into rake so that I can make sure everything works before releasing a gem
       * This will be useful internally also as it will help to keep the gemspec up to date 

 * Architecture
   * Plugin methods should be attached to a module that is included by Nark
     * This way we can easily find out what methods are plugin based and do cool things with the information
   * Think about making components more pluggable.
     * Would be nice is people to easily pick and mix components to do things not originally conceived of
     * Refactor plugin architecture
       * At the moment we are not able to have persistent data with the CLI and reporter.
         * Should be able to jump into the terminal and retain the values coming in from the application Nark is watching

 * Eating my own dog food
   * Come up with use cases for using Nark
   * Put it through it's paces
