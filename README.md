Nark
====

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/baphled/nark) [![Dependency Status](https://gemnasium.com/baphled/nark.png)](https://gemnasium.com/baphled/nark) [![Build Status](https://travis-ci.org/baphled/nark.png)](undefined)

Rack middleware that allows you to easily track and handle rack information of your own choosing.

The idea here is to allow users to easily create modules that plug into the middleware and allow them to track and
monitor information of their choosing.

We'll start off with some basic functionality:
  * log requests
  * total requests
  * Github revision
  * Process ID
  * Status code history

Each of these will be an individual component that plugins into Nark and is exposed via a simple interface.

Installation
------------

`gem install nark`

Then in your config.ru

```
require 'nark'

run Nark.app DummyApp
```

Where `YourApplication` is the web service want to nark on.

Customising
-----------

Nark allows you to easily customise the middleware so that you can
define which reporters to use along with where to find plugins and
whether to load them automatically or not.

The below code snippet provides an example of how you can do this.

```
  Nark.configure do |config|
    config.plugins_paths = 'example/plugins'
    config.reporters = [:HTTP]
    config.load_plugins
  end
```

NOTE: At present you need to set the plugin path before loading all plugins.

Available Reporters
-------------------

  * HTTP

At present this is the only reporter available. Having said that there
will be more coming soon as well as a way to easily integrate your own
reporter.

### HTTP Reporter

The HTTP reporter provides a basic HATEOAS interface.

To determine which plugins are included and what end points to use to
gather the collected data by accessing `http://localhost/nark/` This
will list all available plugins as well as their associated endpoints.

Event Triggers
--------------

Event triggers are used to intercept request and responses when your
application is running. The idea here is that you create your own plugin
that uses both or either of these hooks to gather specific information
about your application and it's state.

Nark, at present, has 2 events handles:
  * before_call
  * after_call

`before_call` is typically used to setup something before a request is
made. Such as request start times or request ip and browser type.

`after_call` takes the responses status, header, body and environment.
Allowing your to manipulate response data as well as have access to the
request environment.

Defining a plugin
-----------------

The grand idea is to allow you to describe request plugins in a
simplicity way. Leaving most of the construction to be dealt with in the
background and let you focus on the on things you really want to do.
Build cool plugins.

For this a DSL is needed.

```
  Nark::Plugin.define :request_times do |plugin|
    plugin.variables :last_request_time => nil, :request_times => []

    plugin.add_hook :before_call do |env|
      @start_time = Time.now
    end

    plugin.add_hook :after_call do |env|
      plugin.last_request_time = (Time.now - @start_time)
      plugin.request_times << {:url => env['PATH_INFO'], :request_time => request_time}
    end
  end
```
 
Upcoming features
-----------------

  * Reporter
    * A configurable interface that allows you to easily plug into Nark and retrieve information that it has received
  * Configuration
    * Easily configure the setup of Nark
      * Reporter
        * What's is Setup
        * Component settings
      * Plugins
      * Where to look
      * Where to save
      * Custom settings
  * Automatically include custom plugins
    * Defined by plugin path

Contributing to Nark
----------------------------
 
* Check out the [[TODO]] and [[TECHDEBT]]
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise 
  necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2012-2013 Yomi Colledge (baphled). See LICENSE.txt for further details.
