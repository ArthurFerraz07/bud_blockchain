require 'dotenv'
require './server'
require './application_runner'

Dotenv.load

node = (ENV['NODE'] || 3000).freeze
environment = (ENV['ENVIRONMENT'] || 'development').freeze
bind = (ENV['BIND'] || '0.0.0.0').freeze

ApplicationRunner.new(environment, node).run

print "⚡ Web Server Running ⚡\n\n"
print "--- Mode  #{environment} ---\n\n"
print "--- Node #{node} ---\n\n"

set :port, node
set :bind, bind

Sinatra::Application.run!

exit 0
