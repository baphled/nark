PLUGIN IDEAS
------------

  * A/B Testing
    * Makes decisions based on configuration information
  * Statsd interface
  * Feature testing
    * Test new features based on past stats on data passed in a run time (via the CLI)
  * Interacts with Nagios
  * Dependency watchdog
    * Alot your system premptively that one of its dependencies has gone down 
      * This could be integrated with another plugin that tells the service to make a change.
  * HATEOS response plugin
    * This way there is no need to polute controllers or business logic with presentational data. 
  * Security watchdog, which alerts other systems when something dodgy appears to be going on 
  * Preventing multiple POST request
   * Some systems are funny at best, this could be useful if a system double charges impatient users 
     * WARNING: There's bigger problems here if this is truely the case. 
