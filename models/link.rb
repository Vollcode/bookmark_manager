require 'dm-migrations'
require 'data_mapper'
require 'dm-postgres-adapter'

class Link
  include DataMapper::Resource

  property :id, Serial
  property :link, String
  property :title, String
end

DataMapper.setup(:default, "postgres://localhost/bookmark_manager")
DataMapper.finalize
DataMapper.auto_upgrade!

# link = Link.create(link: "http://www.makersacademy.com/", title: 'Makers')
