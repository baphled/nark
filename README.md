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

Setup
-----

`gem install nark`

Then in your config.ru

```
require 'nark'
require Dir['/path/of/plugins'].each { |f| requure f }

use Nark::Middleware
run YourApplication
```

Where YourApplication is the web service want to nark on.

Event Handlers
--------------

Nark at present has 2 events handles:
  * before_call
  * after_call

These are used to intercept the request before a request is made and just after a response has been made.

`before_call` is typically used to setup something before a request is made. Such as request start times or request ip
and browser type.

`after_call` takes the responses status, header, body and environment. Allowing your to manipulate response data as
well as have access to the request environment.

Plugin DSL
----------

The grand idea is to allow you to describe request plugins in a simplicist way. Leaving most of the construction to be
dealt with in the background and let you focus on the on things you really want to do.  Build cool plugins.

For this a DSL is needed, this is by no means the end product but simply an the curreny idea for the DSL, I really
have no idea how this is eventually end up.

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
 
The project is far from perfect but I'm working on improving the way it hook works and its flexibility and welcome any
critism (good or bad) and welcome any contributions.

Contributing to Nark
----------------------------
 
* Check out the TODO.md and TECHDEBT.md
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
