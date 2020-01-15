require 'pry'
require 'rest-client'
require 'json'
module RecipeFinder;end #not sure I understand this

class RecipeFinder::API
    BASE_URL = "https://api.edamam.com/search"
   

    def self.recipe_search(q)
      response = RestClient.get(BASE_URL,   {params: {
        app_key: APP_KEY, app_id: APP_ID, 
        q: q
    }
    })
      recipe_array = JSON.parse(response.body)["hits"]

    #   recipe_array.each do |recipe|
    #     RecipeFinder::Recipe.new(recipe)
    #   end
      binding.pry
    end
end

RecipeFinder::API.recipe_search("dinner") #need this for the file to run
#chose lasagna because it's one of the most googled recipes. next to pecan pie and meatloafs -- but lasagna seems more inclusive to dietary restrictions?


#ruby ./lib/recipe_finder/api.rb## to run code in terminal 




