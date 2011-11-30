ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require 'rubygems'
require 'bundler'

Bundler.setup

require 'sinatra/base'
require 'monk/glue'
require 'ohm'
require 'redis-store'
require 'rack-flash'
require 'json'

class Main < Monk::Glue
  set :app_file, __FILE__
  set :haml, { :format => :html5, :ugly => RACK_ENV == 'development' ? false : true }

 
  redis_server = "redis://#{monk_settings(:redis)[:host]}:#{monk_settings(:redis)[:port]}/0"
  # use Rack::Session::Redis, :redis_server => redis_server
  # use Rack::Flash
  # use Rack::Cache

  # enable :raise_errors

end

# Connect to redis database.
Ohm.connect(monk_settings(:redis))

# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

# Load all lib files.
Dir[root_path("lib/**/*.rb")].each do |file|
  require file
end


if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

Main.run! if Main.run?