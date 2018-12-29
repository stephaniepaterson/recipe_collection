require('sinatra')
require('sinatra/contrib/all')
require('pry-byebug')
require_relative('./models/recipe_book')
also_reload('./models/*')

get '/'  do
  @recipes = Recipe.all()
  erb :home
end

get '/:id' do
  @recipes = Recipe.find_by_id( params[:id] )
  erb( :show)
end

get '/new' do
  erb :new
end

post '/' do
  @recipe = Recipe.new ( params )
  @recipe.save()
  erb( :create)
end

post '/:id/delete' do
  recipe = Recipe.find_by_id( params[:id])
  recipe.delete()
  redirect to '/'
end
