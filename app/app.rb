ENV['RACK_ENV'] ||= "development"

require 'sinatra/base'
require './app/data_mapper_setup'
require 'sinatra/flash'

class BookmarkManager < Sinatra::Base

  enable :sessions
  set :sessions_secret, 'super secret'
  register Sinatra::Flash

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links/new' do
    link = Link.create(url: params[:url], title: params[:title])
    add_tag_to_link(link, params[:tag].split(','))
    redirect '/links'
  end

  post '/tags' do
    redirect "tags/#{params[:filter]}"
  end

  get '/tags/:filter' do
    tag = Tag.first(name: params[:filter])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  post '/links/:id/new-tag' do
    link = Link.first(id: params[:id])
    add_tag_to_link(link, params[:tag].split(','))
    redirect '/links'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.create(username: params[:username], email: params[:email], password: params[:password], password_confirmation: params[:confirm_password])
    if user.save
      session[:user_id] = user.id
      redirect '/links'
    else
      flash.next[:password] = 'Are you trying to cheat me m8?' unless params[:password] == params[:confirm_password]
      flash.next[:email] = 'Sorry m8 that email is already taken' if User.first(email: params[:email])
      flash.next[:username] = 'Sorry m8 that username is already taken' if User.first(username: params[:username])
      redirect 'users/new'
    end
  end

  run! if app_file == $0

  helpers do

    def add_tag_to_link link, tags
      tags.each do |tag|
        new_tag = Tag.first_or_create(name: tag.strip)
        link.tags << new_tag
        link.save
      end
    end

    def current_user
      @current_user ||= User.get(session[:user_id])
    end

  end

end
