require 'sinatra/reloader'
require 'sinatra'
require 'httparty'
require_relative 'db_config'
require_relative 'models/movie_caches'
require_relative 'models/search_records'

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
    @info = result.select do |key, value|
      ["Title", "Year", "Rated", "Runtime", "Director"].include?(key)
    end

    @isPoster = true
    if result["Poster"]=="N/A"
      @isPoster = false
    else
      @imgSrc = result["Poster"]
    end

    @actors = result["Actors"].split(',')

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

    erb :movie
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

    erb :movie
  end

  if MovieCaches.find_by(movie_id: movie_id)
    result = MovieCaches.find_by(movie_id: movie_id)
    render_from_buffer(result)
  else
    result = HTTParty.get("http://www.omdbapi.com/?apikey=2f6435d9&i=#{movie_id}").parsed_response
    if result["Response"] == "False"
      render_error(result["Error"])
    else
      render_normal(result)
    end
  end

end

get '/movie_list' do
  movie_name = params[:movie_name]
  result = HTTParty.get("http://www.omdbapi.com/?apikey=2f6435d9&s=#{movie_name}").parsed_response

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

get '/about' do
  erb :about
end
