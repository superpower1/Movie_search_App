# Movie_search_App

verb  | url pattern | description            
------|-------------|------------
get   | /           | home page, search movie
get   | /movie/     | show a single movie_id
get   | /about      | about page
get   | /movie_list | show movie list after search
get   | /user/:id   | show user homepage
get   | /login      | show login page
get   | /user/new   | create new user
post  | /session    | login handler
delete| /session    | logout handler
post  | /like       | add movie to favorite_movie
delete| /like       | remove movie from favorite_movie
post  | /save       | add movie to saved_movie
delete| /save       | remove movie from saved_movie
