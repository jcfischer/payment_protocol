ENV['RACK_ENV'] = 'test'

# require File.expand_path(File.join(File.dirname(__FILE__), "..", "init"))
require File.join(File.dirname(__FILE__), '..', 'init.rb')

require 'rubygems'
require 'bundler'
Bundler.setup :test

require 'rack/test'
require 'rspec'

RSpec.configure do |conf|
  include Rack::Test::Methods
  include RSpec::Expectations
  include RSpec::Matchers

  def app
    Main.new
  end

  conf.before(:all) do
    Ohm.flush
  end

end