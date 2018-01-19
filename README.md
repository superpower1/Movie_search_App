# Movie_search_App

## Technologies
1. jQuery
2. Bootstrap
3. FontAwesome
4. sinatra
5. postgreSQL
6. ActiveRecord

## Approach
1. Draw a wireframe, identify the needs
2. Design the databases
3. Happy coding
4. Deploy using Heroku

## Installation
1. `$ bundle install` to install the required gem
2. `$ ruby main.rb` to run the app

## Unsolved problems
1. Add comment feature
2. Share movie with other users
3. Finish building tag database
4. Rate director and actors
5. Check for duplicate user name in signup page
6. Load more fnction in the list page
7. Guess what kind of movie user may want to see based on tags

## Link to Heroku
[Movie Search App](https://pure-everglades-64611.herokuapp.com/)

## Route table

verb  | url pattern | description            
------|-------------|------------
get   | /           | home page, search movie
get   | /movie/     | show a single movie_id
get   | /about      | about page
get   | /movie_list | show movie list after search
get   | /user/:id   | show user homepage
get   | /login      | show login page
post  | /login      | login handler
get   | /signup     | show sign up page
post  | /signup     | sign up handler
get   | /user/edit  | show user edit page
put   | /user/edit  | edit user profile handler
get   | /session    | return a json indicate whether user is logged in
delete| /session    | logout handler
post  | /like       | add movie to favorite_movie
delete| /like       | remove movie from favorite_movie
post  | /save       | add movie to saved_movie
delete| /save       | remove movie from saved_movie
