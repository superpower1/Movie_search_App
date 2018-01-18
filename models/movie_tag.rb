class MovieTag < ActiveRecord::Base
  belongs_to :movie_buffer
  belongs_to :tag
end
