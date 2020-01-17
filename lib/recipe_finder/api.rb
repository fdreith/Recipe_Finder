

class RecipeFinder::API
    BASE_URL = "https://api.edamam.com/search"

    def self.recipe_search(q)
      response = RestClient.get(BASE_URL, {params: {
        app_key: ENV['API_KEY'], app_id: ENV['API_ID'], 
        q: q
    }
    })
      recipe_array = JSON.parse(response.body)["hits"]

      recipe_array.each do |recipe|
        recipe_hash = recipe["recipe"]
        RecipeFinder::Recipe.new(recipe_hash)
      end      
    end
end

 
#"https://api.edamam.com/search?q=chicken&app_id=${YOUR_APP_ID}&app_key=${YOUR_APP_KEY}&from=0&to=3&calories=591-722&health=alcohol-free"
# RestClient.get 'http://example.com/resource', {params: {id: 50, 'foo' => 'bar'}





