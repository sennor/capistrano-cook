require 'capistrano'
require 'capistrano/cli'
require 'capistrano-cook/helpers'

Capistrano::Configuration.instance.load do
  set :ruby_installer, :rvm
end

Dir.glob(File.join(File.dirname(__FILE__), '/recipes/*.rb')).sort.each { |f| load f }
load Dir.glob(File.join(File.dirname(__FILE__), '/recipes/ruby/rvm.rb')).first
