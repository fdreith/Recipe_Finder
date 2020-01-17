#module RecipeFinder;end

class RecipeFinder::Recipe
    attr_accessor :label, :ingredientLines, :calories, :url, :healthLabels, :dietLabels
    @@all = []
    # @@shopping_list = []
    # @@bookmarked_recipes = []

    def initialize(attrs)
        attrs.each do |key, value| 
            self.send("#{key}=", value) if self.respond_to?("#{key}=")
        end
        self.save
    end 

    def save
        @@all << self
    end 

    def self.all
        @@all
    end 

end