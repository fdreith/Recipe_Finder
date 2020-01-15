module RecipeFinder;end

class RecipeFinder::CLI

    def start
        system('clear')

        puts "Hello! Are you hungry?"
        main_menu_options
    end

    def main_menu_options
        puts "What are you in the mood to cook? Enter a food that sounds good. Be vague if you like."
        puts "Or if you would like to view your shopping list, type '0'."
        puts "Type 'exit' to exit the program"
        main_menu_input
    end

    def main_menu_input
        input = gets.strip
        if input.downcase == "exit"
            goodbye
        elsif input == "0"
            shopping_list
        else 
            RecipeFinder::API.recipe_search(input)
            list_recipes
            sub_menu_options
        end
    end

    def sub_menu_options
        puts "Anything sounds tasty? Type a number associated with the recipe to see the recipe."
        puts "If nothing looks good type 'exit' to exit the program."
    end

    def sub_menu_input
        input = gets.strip

        if input.to_i.between?(1, Recipe_Finder::Recipe.all.length)
            recipe = RecipeFinder::Recipe.all[input.to_i - 1]
            print_recipe(recipe)
          elsif input.downcase == "exit"
            goodbye
          else
            invalid_choice
            sub_menu_options
          end

    end

    def list_recipes
        RecipeFinder::Recipes.all.each.with_index(1) do |recipe, i|
            puts "#{i}. #{recipe.label}"
        end
    end

    def print_recipe(recipe)
        puts "Label: #{recipe.label}"
        puts "Ingredients: #{recipe.ingredients}"
        puts "Calories: #{recipe.calories}"

        add_ingredients_to_shopping_list
    end

    def add_ingredients_to_shopping_list
        puts "Would you like to add these ingredents to your shopping list? Type 'yes' if you would, type 'no' if you would like to continue searching for recipes."
        puts "If nothing looks good type 'exit' to exit the program."

    def add_to_list?
        input = gets.strip
        if input.downcase == "yes"
            @@shopping_list << recipe.ingrdients ## not sure what this will do right now
        elsif input.downcase == "no"
            main_menu_options
        elsif input.downcase == "exit"
            goodbye
        else
            invalid_choice
        end
    end

    def shopping_list
        #view items in shopping list
        @@shopping_list
    end

    def goodbye
        "Goodbye :)"
    end

    def invalid_choice
        puts "That recipe isn't available. Select a number associated with with the recipes you see listed."
    end


end
