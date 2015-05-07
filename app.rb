require('sinatra')
require('sinatra/reloader')
also_reload ('/lib/**/*.rb')
require('./lib/movie')
require('./lib/actor')
require('pg')


DB = PG.connect({:dbname => "movie_database"})

get("/") do
  @movies = Movie.all()
  erb(:index)
end

post("/movies") do
  name = params.fetch("name")
  movie = Movie.new({:name => name, :id => nil})
  movie.save()
  @movies = Movie.all()
  erb(:index)
end

get("/movies/:id") do
  @movie = Movie.find(params.fetch("id").to_i())
  erb(:movie)
end

post("/actors") do
  name = params.fetch("name")
  movie_id = params.fetch("movie_id").to_i()
  actor = Actor.new({:name => name, :movie_id => movie_id})
  actor.save()
  @movie = Movie.find(movie_id)
  erb(:movie)
end
