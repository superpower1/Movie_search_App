-- "Title", "Year", "Rated", "Runtime", "Director", "Poster", "Actors", "Ratings"

CREATE TABLE movie_caches(
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

CREATE TABLE search_records(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  count VARCHAR(255)
);

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  password VARCHAR(255)
);

CREATE TABLE saved_movies(
  id SERIAL PRIMARY KEY,
  movie_id VARCHAR(255),
  user_id VARCHAR(255)
);

CREATE TABLE favorite_movies(
  id SERIAL PRIMARY KEY,
  movie_id VARCHAR(255),
  user_id VARCHAR(255)
);

CREATE TABLE tags(
  id SERIAL PRIMARY KEY,
  content VARCHAR(255)
);

CREATE TABLE movie_tags(
  id SERIAL PRIMARY KEY,
  movie_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES movie_caches(id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

pg_dump -Fc --no-acl --no-owner -h localhost -U superpower1 movie_db > db.dump

heroku pg:backups:restore https://github.com/superpower1/Movie_search_App/raw/master/db.dump DATABASE_URL
