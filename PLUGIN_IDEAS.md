PLUGIN IDEAS
------------

  * A/B Testing
    * Makes decisions based on configuration information
  * Statsd interface
  * Feature testing
    * Test new features based on past stats relating to data passed in a run time (via the CLI)
  * Interacts with Nagios
  * Dependency watchdog
    * Watch your system preemptively check when one of its dependencies has gone down 
  * HATEOAS response plugin
    * This way there is no need to pollute controllers or business logic with presentational data. 
  * Security watchdog, which alerts other systems when something dodgy appears to be going on 
  * Preventing multiple POST request
   * Some systems are funny at best, this could be useful if a system double charges impatient users 
     * WARNING: There's bigger problems here if this is truly the case. 
