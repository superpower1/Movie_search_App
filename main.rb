require 'sinatra/reloader'
require 'sinatra'
require 'httparty'
require_relative 'db_config'
require_relative 'models/movie_caches'
require_relative 'models/search_records'
require_relative 'models/users'
require_relative 'models/favorite_movies'
require_relative 'models/saved_movies'

# sinatra provide this feature
enable :sessions

helpers do
  def current_user
    Users.find_by(id: session[:user_id])
  end

  def logged_in?
    # Use ! to change a object to boolean
    !!current_user
  end

end

def render_error(msg)
  @error_msg = msg
  erb :not_found
end

get '/' do
  @history = MovieCaches.last(5).reverse
  erb :index
end

get '/movie' do

  movie_id = params[:movie_id]

  def render_normal(result)

    if r=result["Ratings"].find{|rating| rating["Source"] == "Rotten Tomatoes"}
      @tomato = r["Value"]
    else
      @tomato = "N/A"
    end

    new_record = MovieCaches.create(
      title: result['Title'],
      year: result['Year'],
      rated: result['Rated'],
      runtime: result['Runtime'],
      director: result['Director'],
      poster: result['Poster'],
      actors: result['Actors'],
      ratings: @tomato,
      movie_id: result['imdbID']
    )

    # erb :movie
  end

  def render_from_buffer(result)
    @info = {
      Title: result.title,
      Year: result.year,
      Rated: result.rated,
      Runtime: result.runtime,
      Director: result.director
    }

    @isPoster = true
    if result.poster=="N/A"
      @isPoster = false
    else
      @imgSrc = result.poster
    end

    @actors = result.actors.split(',')
    @tomato = result.ratings
    @movie_id = result.movie_id

    erb :movie
  end

  if !MovieCaches.find_by(movie_id: movie_id)
    result = HTTParty.get("http://www.omdbapi.com/?apikey=2f6435d9&i=#{movie_id}").parsed_response
    if result["Response"] == "False"
      render_error(result["Error"])
    else
      render_normal(result)
    end
  end

  result = MovieCaches.find_by(movie_id: movie_id)
  render_from_buffer(result)

end

get '/movie_list' do
  movie_name = params[:movie_name]
  result = HTTParty.get("http://www.omdbapi.com/?apikey=2f6435d9&s=#{movie_name}&type=movie").parsed_response

  def store_search(name)
    if SearchRecords.find_by(name: name)
      record=SearchRecords.find_by(name: name)
      record.count = record.count.to_i+1
      record.save
    else
      new_search = SearchRecords.create(
        name: name,
        count: 1
      )
    end
  end

  def render_normal(result)
    @movie_list = result["Search"]
    erb :movie_list
  end

  if result["Response"] == "False"
    render_error(result["Error"])
  else
    store_search(movie_name)
    render_normal(result)
  end

end

get '/login' do
  erb :login
end

post '/session' do
  user = Users.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    # session is a hash that can be access globally in the server
    session[:user_id] = user.id
    redirect '/'
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/login'
end

get '/session' do
  result = {
    "login": logged_in?
    }
  return result.to_json
end

post '/like' do
  if movie = FavoriteMovies.find_by(movie_id: params[:movie_id], user_id: params[:user_id])
    movie.delete
    return "unliked"
  else
    FavoriteMovies.create(
      movie_id: params[:movie_id],
      user_id: params[:user_id]
    )
    return "liked"
  end
end

post '/save' do
  if movie = SavedMovies.find_by(movie_id: params[:movie_id], user_id: params[:user_id])
    movie.delete
    return "deleted"
  else
    SavedMovies.create(
      movie_id: params[:movie_id],
      user_id: params[:user_id]
    )
    return "saved"
  end
end

get '/about' do
  erb :about
end

get '/user/new' do
  erb :new_user
end

post '/user/new' do

end
