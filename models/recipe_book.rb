require( 'pg' )

class Recipe

  attr_accessor :name, :duration, :ingredients
  attr_reader :id

  def initialize( options )
    @name = options['name']
    @duration = options['duration'].to_i
    @ingredients = options['ingredients']
    @id = options['id'].to_i if options['id']
  end

  def save()
    db = PG.connect( { dbname: 'recipe_collection', host: 'localhost' })
    sql =
      "INSERT INTO recipes
      (name,
      duration,
      ingredients)
      VALUES
      ($1, $2, $3)
      RETURNING *"
    values = [@name, @duration, @ingredients]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]["id"].to_i
    db.close()
  end

  def update()
    db = PG.connect( {dbname: 'recipe_collection', host: 'localhost'} )
    sql = "UPDATE recipes
    SET (
      name,
      duration,
      ingredients
      ) =
      ($1, $2, $3)
      WHERE id = $5"
    values =[@name, @duration, @ingredients, @id]
    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close()
  end

  def delete()
    db = PG.connect( {dbname: 'recipe_collection', host: 'localhost'} )
    sql = "DELETE FROM recipes WHERE id = $1"
    values = [@id]
    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", values)
    db.close
  end

  def Recipe.find_by_name(name)
    db = PG.connect( {dbname: 'recipe_collection', host: 'localhost'})
    sql = "SELECT * from recipes WHERE name = $1"
    values= [name]
    db.prepare("find_by_name", sql)
    results_array = db.exec_prepared("find_by_name", values)
    db.close()
    recipe_hash = results_array[0]
    recipe = Recipe.new(recipe_hash)
    return recipe
  end

  def Recipe.find_by_id(id)
    db = PG.connect( {dbname: 'recipe_collection', host: 'localhost'})
    sql = "SELECT * from recipes WHERE id = $1"
    values = [id]
    db.prepare("find_by_id", sql)
    results_array = db.exec_prepared("find_by_id", values)
    db.close()
    result = Recipe.new(results_array.first)
    return result
  end

  #def Recipe.find_by_ingredient(ingredients)
  #  db = PG.connect( { dbname: 'recipe_collection', host: 'localhost'})
  #  sql = "SELECT * from recipes WHERE ingredients LIKE $1"
  #  values = [ingredients]
  #  db.prepare("find_by_ingredient", sql)
  #  results_array = db.exec_prepared("find_by_ingredient", values)
  #  db.close()
  #  recipe_hash = results_array[0]
  #  recipe = Recipe.new(recipe_hash)
  #  return recipe
  #end

  def Recipe.delete_all()
    db = PG.connect( {dbname: 'recipe_collection', host: 'localhost'} )
    sql = "DELETE FROM recipes"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close
  end

  def Recipe.all()
    db = PG.connect( {dbname: 'recipe_collection', host: 'localhost'} )
    sql = "SELECT * FROM recipes"
    db.prepare("all", sql)
    recipes = db.exec_prepared("all")
    db.close()
    return recipes.map {|recipe| Recipe.new(recipe)}
  end

end
