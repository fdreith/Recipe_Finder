module RecipeFinder;end

class RecipeFinder::Recipe
    attr_accessor :label, :ingredients, :calories
    @@all = []
    @@shopping_list = []

    def initialize(attrs)
        attrs.each do |key, value| 
            self.send("#{key}=", value) if self.respond_to?("#{key}=")
        end
        self.save
    end 

    def save
        @@all << self
    end 

    # def self.create(attrs)
    #     new_thing = new(attrs)
    #     new_thing.save
    # end 

    def self.all
        @@all
    end 
end