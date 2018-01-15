-- "Title", "Year", "Rated", "Runtime", "Director", "Poster", "Actors", "Ratings"

CREATE TABLE movie_cache(
  id SERIAL PRIMARY KEY,
  title VARCHAR(255),
  year VARCHAR(4),
  rated VARCHAR(255),
  runtime VARCHAR(255),
  Director VARCHAR(255),
  poster VARCHAR(400),
  actors VARCHAR(400),
  ratings VARCHAR(255),
  movie_id VARCHAR(255)
);

CREATE TABLE search_record(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  count VARCHAR(255)
);
