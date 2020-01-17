class RecipeFinder::CLI

    @@shopping_list = []
    @@viewed_recipes = []
    @@bookmarked_recipes = []
    @@random_search_keywords = ["grain","tofu","tempeh","lentils","beans","vegetarian","vegan","gluten-free","green",
    "salad","tacos","pasta","beef","chicken","turkey","pork","Indian","Italian","Chinese","Asian","Japanese","Thai",
    "Breakfast","Bacon","keto","low calorie","pie","cookies","lasagna","stuffed squash","bread","chili","soup",
    "mexican","wings","pickled","enchilada","squash","broccoli","curry","ramen"]

    def start
        system('clear')
        puts  
        puts "                       •••••••••••••••••••••••••••••••••"
        puts "                           ••••••••••••••••••••••••     "
        puts "                            Hello! Are you hungry?      "
        puts "                           ••••••••••••••••••••••••     "
        puts "                       •••••••••••••••••••••••••••••••••"
        puts
        first_main_menu_options
    end

    def first_main_menu_options
        puts
        puts "Enter a keyword for the dish you would like to cook."
        puts "Be vague if you like :)"
        puts
        puts "Aren't sure what you want to cook?"
        puts "Type 'suprise', and we can do a random search for you!"
        puts
        puts "Type 'exit' to exit the program." 
        puts
        main_menu_input
    end

    def main_menu_options
        puts
        puts "                         <<<<< MAIN MENU >>>>>"
        puts
        puts "To search again, enter a keyword for the dish you would like to cook."
        puts "Or type 'suprise' and we will randomly pick a food to search."
        puts "If you would like to view your bookmarked recipes, type '000'"
        puts "If you would like to view your shopping list, type '00'." 
        puts "If you would like to view your previously viewed recipes, type '0'."
        puts
        puts "Type 'exit' to exit the program." 
        puts
        main_menu_input
    end

    def main_menu_input
        input = gets.strip
        puts
        puts "       ˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚"
        puts
        if input.downcase == "exit"
            goodbye
        elsif input == "000"
            print_bookmarked_recipes
        elsif input == "00"
            print_shopping_list
        elsif input == "0" 
            print_viewed_recipes
        elsif input == "suprise"
            item = @@random_search_keywords.sample
            RecipeFinder::API.recipe_search(item)
            list_recipes
            sub_menu_options
        else 
            RecipeFinder::API.recipe_search(input)
            list_recipes
            sub_menu_options
        end
    end

    def list_recipes
        puts
        puts "Does anything sound appetizing?"
        puts
        RecipeFinder::Recipe.all.each.with_index(1) do |recipe, i|
            puts "  #{i}. #{recipe.label}: #{recipe.dietLabels.join}"
        end
        puts
    end

    def sub_menu_options
        puts
        puts "To view the recipe and ingredients, choose a corresponding number with"
        puts "the recipe you would like to view." 
        puts "If nothing looks good, type another food to continue searching."
        puts "Or type 'suprise'." 
        puts
        puts "Or type 'exit' to exit the program." 
        puts
        sub_menu_input
    end

    def sub_menu_input
        input = gets.strip
        puts
        puts "       ˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚"
        puts
        if input.to_i.between?(1, RecipeFinder::Recipe.all.length)
            @selected_recipe = RecipeFinder::Recipe.all[input.to_i - 1]
            print_recipe(@selected_recipe)
          elsif input.downcase == "exit"
            goodbye
          elsif input == "suprise"
            item = @@random_search_keywords.sample
            RecipeFinder::API.recipe_search(item)
            list_recipes
            sub_menu_options
          else
            RecipeFinder::API.recipe_search(input)
            list_recipes
            sub_menu_options
          end
    end

    def print_recipe(recipe)
        @@viewed_recipes << recipe 
        puts
        puts "#{recipe.label}:" 
        puts
        puts "Ingredients:"
        recipe.ingredientLines.each do |ingredient|
            puts "• #{ingredient}"
        end
        puts
        puts "#{recipe.calories.to_i.round(1)} calories" 
        puts
        puts "This recipe is:"
        recipe.healthLabels.each do |health|
            puts "• #{health}"
        end
        puts
        puts "To view recipe directions, visit: #{recipe.url}" 
        puts
        add_ingredients_options
    end

    def add_ingredients_options
        puts
        puts "Would you like to add these ingredents to your shopping list?"
        puts "If so, type 'yes'." 
        puts "If you would like to view the previous list of options, type 'back'." 
        puts "To search again, enter a keyword for the dish you would like to cook."
        puts
        puts "Type 'exit' to exit the program." 
        puts
        add_ingredients_input
    end

    def add_ingredients_input
        input = gets.strip
        puts
        puts "       ˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚"
        puts
        if input.downcase == "yes"
            @selected_recipe.ingredientLines.each do |ingredient|
                @@shopping_list << ingredient
            end
            @@bookmarked_recipes << (@selected_recipe.url.dup)  
            main_menu_options
        elsif input.downcase == "back"
            list_recipes
            puts
            sub_menu_options
        elsif input.downcase == "exit"
            goodbye
        elsif input == "suprise"
            item = @@random_search_keywords.sample
            RecipeFinder::API.recipe_search(item)
            list_recipes
            sub_menu_options
        else
            RecipeFinder::API.recipe_search(input)
            list_recipes
            sub_menu_options
        end
    end

    def print_shopping_list
        if @@shopping_list.empty?
            puts "Your shopping list is empty, add ingredients or search for recipes"
            puts "and add the ingredients directly from the recipe."
        else 
            puts "Your Shopping List:"
            puts
            puts @@shopping_list 
            puts
        end
        shopping_list_options
    end

    def shopping_list_options
        puts 
        puts "Did you go to the store? Type 'clear' to delete all items in your list." 
        puts "If you would like to add an item, type it in." 
        puts "Type 'menu', to go back to the main menu, and search again."
        puts
        puts "Type 'exit' to exit the program."
        puts
        shopping_list_input
    end

    def shopping_list_input
        input = gets.strip
        puts
        puts "       ˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚˚"
        puts
        if input.downcase == "clear"
            clear_list
            main_menu_options
        elsif input.downcase == "menu"
            main_menu_options
        elsif input.downcase == "exit"
            goodbye
        else
            @@shopping_list << input 
            print_shopping_list
        end
    end

    def clear_list
        @@shopping_list.clear
    end

    def selected_recipe
        @selected_recipe
    end

    def shopping_list
        @@shopping_list 
    end

    def viewed_recipes 
        @@viewed_recipes
    end

    def bookmarked_recipes
        @@bookmarked_recipes
    end

    def print_viewed_recipes
        puts
        if @@viewed_recipes.empty?
            puts "You haven't viewed any recipes, after you have selected a recipe, it will be listed here."
        else 
            puts "Here are the recipes you've viewed. Go to their website to get the recipe instructions."
            puts
            @@viewed_recipes.each.with_index(1) do |recipe, i|
                puts "#{i}. #{recipe.label}:   #{recipe.url}"
            end
        end
        puts
        main_menu_options
    end

    def print_bookmarked_recipes
        puts
        if @@bookmarked_recipes.empty?
            puts "You haven't bookmarked any recipes yet, after you have selected a recipe, it will be listed here."
        else 
            puts "Here are your bookmarked recipes. Go to their website to get the recipe instructions."
            puts
            puts @@bookmarked_recipes.each do |url|
                puts url
                puts 
            end
        end
        puts
        main_menu_options
    end

    def goodbye
        puts
        puts "Goodbye :) Come back again when you're hungry."
        puts
    end

    def invalid_choice 
        puts
        puts "Whoops! You entered an invalid option. Take a look at the options and try again."
        puts
    end


end
