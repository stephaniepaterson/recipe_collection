require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('./models/recipe_book')
also_reload('./models/*')

get '/'  do
  @recipes = Recipe.all()
  erb :home
end

post '/' do
  @recipe = Recipe.new ( params )
  @recipe.save()
  erb( :create)
end

get '/new' do
  erb :new
end

get '/:id' do
  @recipes = Recipe.find_by_id( params[:id] )
  erb( :show)
end

post '/:id/delete' do
  recipe = Recipe.find_by_id( params[:id])
  recipe.delete()
  redirect to '/'
end
