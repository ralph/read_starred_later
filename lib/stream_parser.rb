require "rubygems"
require "bundler"
Bundler.setup

require 'tweetstream'

begin
  config = YAML.load_file('config.yml')
rescue Errno::ENOENT
  puts 'No config.yml file found, which is needed to run this script. You can copy config.yml.example as a starting point.'
  Process.exit
end

users = YAML.load_file('data/users.yml')

TweetStream::Client.new(config[:user], config[:password]).follow(*users) do |status|
  puts "#{status.text}"
end
