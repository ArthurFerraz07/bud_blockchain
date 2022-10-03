# frozen_string_literal: true

require 'bundler'

Bundler.require(:default)

# Set port of web server
# set :port, 3000

# Set root of web server
get '/' do
  'Put this in your **** & ***** it!'
end

print "⚡App Running ⚡\n"
