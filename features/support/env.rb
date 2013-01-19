require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec/expectations'
require "aruba/cucumber"

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'nark'

After("@plugin-dsl") do
  Nark.available_plugins.each { |plugin| Nark::Plugin.undefine plugin }
end
