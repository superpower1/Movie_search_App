require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'movie_db',
  username: 'superpower1'
}

ActiveRecord::Base.establish_connection(options)
