# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: nark 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "nark".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["baphled".freeze]
  s.date = "2017-11-13"
  s.description = "Allows you to build plugins that can be used to nark on various parts of your application".freeze
  s.email = "baphled@boodah.net".freeze
  s.executables = ["nark".freeze]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".gitignore",
    ".rspec",
    ".ruby-gemset",
    ".ruby-version",
    ".simplecov",
    ".travis.yml",
    "Gemfile",
    "LICENSE.txt",
    "PLUGIN_IDEAS.md",
    "README.md",
    "Rakefile",
    "TECHDEBT.md",
    "TODO.md",
    "VERSION",
    "bin/nark",
    "config/cucumber.yml",
    "example/.rvmrc",
    "example/Gemfile",
    "example/Gemfile.lock",
    "example/config.ru",
    "example/config/nark.yml",
    "example/dummy_app.rb",
    "example/plugins/requests.rb",
    "example/plugins/status_report.rb",
    "features/command_line_interaction.feature",
    "features/configuration_settings.feature",
    "features/generating_a_plugin.feature",
    "features/nark_middleware.feature",
    "features/plugin_dsl.feature",
    "features/reporter.feature",
    "features/reporter_http.feature",
    "features/step_definitions/http_reporting_steps.rb",
    "features/step_definitions/nark_steps.rb",
    "features/step_definitions/plugin_steps.rb",
    "features/step_definitions/reporter_steps.rb",
    "features/step_definitions/undefine_plugin_steps.rb",
    "features/support/env.rb",
    "features/support/example_app_env.rb",
    "features/total_requests_plugin.feature",
    "features/undefining_a_plugin.feature",
    "lib/nark.rb",
    "lib/nark/cli.rb",
    "lib/nark/configuration.rb",
    "lib/nark/dsl.rb",
    "lib/nark/exceptions.rb",
    "lib/nark/macros.rb",
    "lib/nark/middleware.rb",
    "lib/nark/plugin.rb",
    "lib/nark/plugin/event.rb",
    "lib/nark/plugin/events.rb",
    "lib/nark/report_broker.rb",
    "lib/nark/reporter/http.rb",
    "nark.gemspec",
    "plugins/request_times.rb",
    "plugins/requests.rb",
    "plugins/revisions.rb",
    "plugins/status_report.rb",
    "plugins/template.erb",
    "spec/fixtures/config/nark.yml",
    "spec/fixtures/plugins/dummy_plugin.rb",
    "spec/integration/plugin_dsl_spec.rb",
    "spec/integration/running_multiple_plugins_spec.rb",
    "spec/nark/cli_spec.rb",
    "spec/nark/configuration_spec.rb",
    "spec/nark/dsl_spec.rb",
    "spec/nark/macros_spec.rb",
    "spec/nark/middleware_spec.rb",
    "spec/nark/plugin/event_spec.rb",
    "spec/nark/plugin/events_spec.rb",
    "spec/nark/plugin_spec.rb",
    "spec/nark_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/create_plugin.rb"
  ]
  s.homepage = "http://github.com/baphled/nark".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.2".freeze
  s.summary = "Narks on your application like a dirty little snitch".freeze
  s.test_files = ["features/command_line_interaction.feature".freeze, "features/configuration_settings.feature".freeze, "features/generating_a_plugin.feature".freeze, "features/nark_middleware.feature".freeze, "features/plugin_dsl.feature".freeze, "features/reporter.feature".freeze, "features/reporter_http.feature".freeze, "features/step_definitions/http_reporting_steps.rb".freeze, "features/step_definitions/nark_steps.rb".freeze, "features/step_definitions/plugin_steps.rb".freeze, "features/step_definitions/reporter_steps.rb".freeze, "features/step_definitions/undefine_plugin_steps.rb".freeze, "features/support/env.rb".freeze, "features/support/example_app_env.rb".freeze, "features/total_requests_plugin.feature".freeze, "features/undefining_a_plugin.feature".freeze, "spec/fixtures/config/nark.yml".freeze, "spec/fixtures/plugins/dummy_plugin.rb".freeze, "spec/integration/plugin_dsl_spec.rb".freeze, "spec/integration/running_multiple_plugins_spec.rb".freeze, "spec/nark/cli_spec.rb".freeze, "spec/nark/configuration_spec.rb".freeze, "spec/nark/dsl_spec.rb".freeze, "spec/nark/macros_spec.rb".freeze, "spec/nark/middleware_spec.rb".freeze, "spec/nark/plugin/event_spec.rb".freeze, "spec/nark/plugin/events_spec.rb".freeze, "spec/nark/plugin_spec.rb".freeze, "spec/nark_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/support/create_plugin.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<rubygems-tasks>.freeze, ["~> 0.2.4"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.7.0"])
      s.add_development_dependency(%q<fakefs>.freeze, ["~> 0.11.3"])
      s.add_development_dependency(%q<cucumber>.freeze, ["<= 3.0.1"])
      s.add_development_dependency(%q<capybara>.freeze, ["<= 2.15.4"])
      s.add_development_dependency(%q<aruba>.freeze, ["<= 0.14.2"])
      s.add_development_dependency(%q<jeweler>.freeze, ["<= 2.3.7"])
      s.add_development_dependency(%q<rack-test>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, ["<= 0.11.2"])
      s.add_development_dependency(%q<sinatra>.freeze, ["<= 2.0.0"])
    else
      s.add_dependency(%q<activesupport>.freeze, [">= 0"])
      s.add_dependency(%q<rubygems-tasks>.freeze, ["~> 0.2.4"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.7.0"])
      s.add_dependency(%q<fakefs>.freeze, ["~> 0.11.3"])
      s.add_dependency(%q<cucumber>.freeze, ["<= 3.0.1"])
      s.add_dependency(%q<capybara>.freeze, ["<= 2.15.4"])
      s.add_dependency(%q<aruba>.freeze, ["<= 0.14.2"])
      s.add_dependency(%q<jeweler>.freeze, ["<= 2.3.7"])
      s.add_dependency(%q<rack-test>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, ["<= 0.11.2"])
      s.add_dependency(%q<sinatra>.freeze, ["<= 2.0.0"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_dependency(%q<rubygems-tasks>.freeze, ["~> 0.2.4"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.7.0"])
    s.add_dependency(%q<fakefs>.freeze, ["~> 0.11.3"])
    s.add_dependency(%q<cucumber>.freeze, ["<= 3.0.1"])
    s.add_dependency(%q<capybara>.freeze, ["<= 2.15.4"])
    s.add_dependency(%q<aruba>.freeze, ["<= 0.14.2"])
    s.add_dependency(%q<jeweler>.freeze, ["<= 2.3.7"])
    s.add_dependency(%q<rack-test>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, ["<= 0.11.2"])
    s.add_dependency(%q<sinatra>.freeze, ["<= 2.0.0"])
  end
end

