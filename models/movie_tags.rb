class MovieTags < ActiveRecord::Base
  belongs_to :movie_caches
  belongs_to :tags
end
