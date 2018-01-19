# require 'sinatra/reloader'
require 'sinatra'
require 'httparty'
require_relative 'db_config'
require_relative 'models/movie_buffer'
require_relative 'models/search_record'
require_relative 'models/user'
require_relative 'models/favorite_movie'
require_relative 'models/saved_movie'

# sinatra provide this feature
enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    # Use ! to change a object to boolean
    !!current_user
  end

  def user_favor_movie
    movie_list = []
    favor_movies = FavoriteMovie.where(user_id: session[:user_id]).order("id DESC")
    favor_movies.each do |movie|
      movie_list.push(MovieBuffer.find_by(movie_id: movie.movie_id))
    end
    movie_list
  end

  def is_liked?(movie_id)
    if FavoriteMovie.find_by(user_id: session[:user_id], movie_id: movie_id)
      return true
    else
      return false
    end
  end

  def is_saved?(movie_id)
    if SavedMovie.find_by(user_id: session[:user_id], movie_id: movie_id)
      return true
    else
      return false
    end
  end

end

def render_error(msg)
  @error_msg = msg
  erb :not_found
end

get '/' do
  @history = MovieBuffer.last(5).reverse
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

    new_record = MovieBuffer.create(
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

  if !MovieBuffer.find_by(movie_id: movie_id)
    result = HTTParty.get("http://www.omdbapi.com/?apikey=2f6435d9&i=#{movie_id}").parsed_response
    if result["Response"] == "False"
      render_error(result["Error"])
    else
      render_normal(result)
    end
  end

  result = MovieBuffer.find_by(movie_id: movie_id)
  render_from_buffer(result)

end

get '/movie_list' do
  movie_name = params[:movie_name]
  result = HTTParty.get("http://www.omdbapi.com/?apikey=2f6435d9&s=#{movie_name}&type=movie").parsed_response

  def store_search(name)
    if SearchRecord.find_by(name: name)
      record=SearchRecord.find_by(name: name)
      record.count = record.count.to_i+1
      record.save
    else
      new_search = SearchRecord.create(
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
  @user = User.new
  session[:return_to] = request.referer
  erb :login
end

post '/login' do
  @user = User.find_by(email: params[:email])
  if @user && @user.authenticate(params[:password])
    session[:user_id] = @user.id
    redirect '/'
  else
    @user ||= User.new(email: params[:email])
    @login_failed = true
    erb :login
  end
end

post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    # session is a hash that can be access globally in the server
    session[:user_id] = user.id
    redirect session.delete(:return_to)
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end

get '/session' do
  result = {
    "login": logged_in?
    }
  return result.to_json
end

post '/like' do
  if movie = FavoriteMovie.find_by(movie_id: params[:movie_id], user_id: params[:user_id])
    movie.delete
    return "unliked"
  else
    FavoriteMovie.create(
      movie_id: params[:movie_id],
      user_id: params[:user_id]
    )
    return "liked"
  end
end

post '/save' do
  if movie = SavedMovie.find_by(movie_id: params[:movie_id], user_id: params[:user_id])
    movie.delete
    return "deleted"
  else
    SavedMovie.create(
      movie_id: params[:movie_id],
      user_id: params[:user_id]
    )
    return "saved"
  end
end

get '/about' do
  erb :about
end

get '/signup' do
  session[:return_to] = request.referer
  erb :signup
end

post '/signup' do
  if User.find_by(email: params[:email])
    erb :signup
  else
    User.create(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )
    session[:user_id] = User.find_by(email: params[:email]).id
    redirect session.delete(:return_to)
  end
end

get '/user' do
  @movie_list = user_favor_movie
  erb :user
end

get '/user/edit' do
  session[:return_to] = request.referer
  erb :user_edit
end

get '/user/edit/:field' do
  case params["field"]
  when 'name'
    erb :user_edit_name
  when 'email'
    erb :user_edit_email
  when 'pwd'
    erb :user_edit_pwd
  else
    erb :user_edit
  end
end

post '/user/edit/pwd' do
  user = current_user
  if user && user.authenticate(params[:old_pwd])
    user.password = params[:new_pwd]
    user.save
    session[:user_id] = nil
    redirect '/'
  else
    erb :user_edit_pwd
  end
end

post '/user/edit/name' do
  user = current_user
  if user && user.authenticate(params[:pwd])
    user.name = params[:name]
    user.save
    redirect '/user/edit'
  else
    erb :user_edit_name
  end
end
