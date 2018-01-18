class Tag < ActiveRecord::Base
  has_many :movie_tags
  has_many :movie_buffers, through: :movie_tags
end
