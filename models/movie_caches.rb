class MovieCaches < ActiveRecord::Base
  has_many :movie_tags
  has_many :tags, through: :movie_tags
end
