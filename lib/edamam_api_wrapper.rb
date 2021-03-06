class EdamamApiWrapper
  BASE_URL = "https://api.edamam.com/search?"
  ID_AND_KEY = "&app_id=#{ENV["EDAMAM_ID"]}&app_key=#{ENV["EDAMAM_KEY"]}"

  def self.search(query)
    url = BASE_URL + "q=" + query + ID_AND_KEY + "&to=50"
    data = HTTParty.get(url)
    recipes = []
    unless data["hits"].empty?
      data["hits"].each do |response|
        api_data = response["recipe"]
        recipes << self.create_recipe(api_data)
      end
    end
    return recipes
  end

  def self.find_recipe(id)
    url = BASE_URL + "r=" + id + ID_AND_KEY
    data = HTTParty.get(url)
    recipe = ""
    unless data.empty?
      recipe = self.create_recipe(data[0])
    end
    return recipe
  end


private
  def self.create_recipe(api_data)
    recipe = Recipe.new(
      api_data["label"],
      api_data["uri"],
      api_data["image"],
      api_data["url"],
      api_data["ingredientLines"],
      {
        diet: api_data["dietLabels"],
        health: api_data["healthLabels"],
      }
    )
    return recipe
  end


end
