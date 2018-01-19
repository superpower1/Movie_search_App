# Movie_search_App

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
