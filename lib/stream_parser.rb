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

users = YAML.load_file('data/users.yml')

TweetStream::Client.new(config[:user], config[:password]).follow(*users.keys) do |status|
  if true #status.favorited
    user = users[status.user.id.to_i]
    username = user[:instapaper_username]
    password = user[:instapaper_password]
    Instapaper.add_url(username, 'http://www.heise.de', password)
  end
  puts "#{status.inspect}"
end
