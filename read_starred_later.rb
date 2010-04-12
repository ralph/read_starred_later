require "rubygems"
require "bundler"
Bundler.setup

require 'yaml'
require 'sinatra/base'
require 'padrino-helpers'
require 'erubis'

class ReadStarredLater < Sinatra::Base
  register Padrino::Helpers

  set :root, File.dirname(__FILE__)
  set :views, File.dirname(__FILE__) + '/views'
  set :public, File.dirname(__FILE__) + '/public'
  set :reload, true

  def initialize
    super
    user_file = 'data/users.yml'
    @users = (File.exists?(user_file) ? YAML.load_file(user_file) : {})
  end

  get '/' do
    erubis :index
  end

  post '/add_user' do
    twitter_id = params['twitter_id']
    instapaper_username = params['instapaper_username']
    instapaper_password = params['instapaper_password']
    add_user(twitter_id, instapaper_username, instapaper_password)
    erubis :add_user
  end


private
  def add_user(twitter_id, instapaper_username, instapaper_password = '')
    @users = @users.merge(twitter_id.to_i => { :instapaper_username => instapaper_username, :instapaper_password => instapaper_password })
    f = File.open('data/users.yml', 'w')
    f.write @users.to_yaml
    f.close
  end
end
