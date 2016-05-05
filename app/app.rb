ENV['RACK_ENV'] ||= "development"

require 'sinatra/base'
require './app/data_mapper_setup'

class BookmarkManager < Sinatra::Base

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb :index
  end

  get '/links/new' do
    erb :newlink
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
    erb :index
  end

  post '/links/:id/new-tag' do
    link = Link.first(id: params[:id])
    add_tag_to_link(link, params[:tag].split(','))
    redirect '/links'
  end

  run! if app_file == $0

  private

  def add_tag_to_link link, tags
    tags.each do |tag|
      new_tag = Tag.first_or_create(name: tag.strip)
      link.tags << new_tag
      link.save
    end
  end

end
