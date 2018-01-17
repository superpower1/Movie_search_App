class Tags < ActiveRecord::Base
  has_many :movie_tags
  has_many :movie_caches, through: :movie_tags
end
