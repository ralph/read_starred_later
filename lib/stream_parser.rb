require "rubygems"
require "bundler"
Bundler.setup

require 'tweetstream'
require 'yaml'
require File.expand_path('..', __FILE__) + '/instapaper'

begin
  config = YAML.load_file('config.yml')
rescue Errno::ENOENT
  puts 'No config.yml file found, which is needed to run this script. You can copy config.yml.example as a starting point.'
  Process.exit
end

users = YAML.load_file('data/users.yml').keys

TweetStream::Client.new(config[:user], config[:password]).follow(*users) do |status|
  if status.favorited
    user = users[status.user.id]
    username = user[:username]
    password = user[:password]
    Instapaper.add_url(username, password, 'http://www.heise.de')
  end

  puts "#{status.text}"
  puts "#{status.inspect}"
end
