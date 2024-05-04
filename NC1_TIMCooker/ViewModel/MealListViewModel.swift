//
//  MealListViewModel.swift
//  NC1_TIMCooker
//
//  Created by Eldenabih Tavirazin Lutvie on 01/05/24.
//

import Foundation

class MealListViewModel: ObservableObject {
    @Published private(set) var meals: [Meal] = [] // Published for binding with the View
    @Published private(set) var hasIngredients: Bool = false // Tracks if ingredients have been uploaded
    @Published private(set) var userIngredients: String = "egg,  bell pepper, milk, butter, cheese, mushroom, garlic, parsley, olive oil" // Stores user's available ingredients
    
    func filterMeals() {
        if !userIngredients.isEmpty {
          meals = meals.filter { meal in
            // Implement logic to check if meal ingredients are a subset of user ingredients
//            let userIngredientList = userIngredients.components(separatedBy: .whitespacesAndNewlines)
//            let mealIngredientList = meal.ingredients.components(separatedBy: .whitespacesAndNewlines)
              let userIngredientList = userIngredients.components(separatedBy: ", ")
              let mealIngredientList = meal.ingredients.components(separatedBy: ", ")
            return Set(mealIngredientList).isSubset(of: Set(userIngredientList))
          }
        }
      }
    
//    func handleUploadPhoto(ingredients: String) { // Add ingredients as a parameter
//        hasIngredients = true
//        userIngredients = ingredients // Update user ingredients
//        filterMeals() // Filter meals after ingredient update
//      }
    
    
    func loadMeals() {
        // Implement logic to load meals from your data source (e.g., API, local storage)
        // Replace with your actual data fetching logic
        meals = [
            Meal(name: "Omelette", imageUrl: "omelette", ingredients: "egg,  bell pepper, milk, butter, cheese", instructions: "Crack the eggs into a bowl. Add salt, pepper, and milk or water if using. Beat the eggs with a fork or whisk until well mixed and slightly frothy. Heat a non-stick skillet over medium heat and add the butter or oil, swirling to coat the pan evenly. Pour the beaten eggs into the skillet, tilting the pan to spread them evenly. Let the eggs cook undisturbed for a minute or so until the edges start to set. Using a spatula, gently lift the edges of the omelette and tilt the pan to let any uncooked egg flow to the edges. Once the top is mostly set but still slightly runny, add your desired fillings to one half of the omelette. Fold the other half of the omelette over the fillings to create a half-moon shape. Cook for another minute or until the eggs are fully set and the fillings are heated through. Slide the omelette onto a plate and serve hot."),
            Meal(name: "Salmon Pasta", imageUrl: "salmon_pasta", ingredients: "salmon, pasta, butter, garlic, lemon, parsley, salt, pepper, parmesan cheese", instructions: "Cook pasta according to package instructions. While pasta is cooking, heat butter in a skillet over medium heat. Add minced garlic and cook until fragrant. Add diced salmon to the skillet and cook until it flakes easily with a fork. Squeeze lemon juice over the salmon and season with salt and pepper. Add cooked pasta to the skillet, tossing to coat with the salmon and butter sauce. Stir in chopped parsley and grated parmesan cheese. Cook for another minute until everything is heated through and well combined. Serve hot, garnished with additional parsley and parmesan cheese if desired."),
            Meal(name: "Almond Butter Toast", imageUrl: "almond_butter_toast", ingredients: "toast bread, almond butter, blueberry", instructions: "Toast bread until golden brown. Spread almond butter evenly on the toast. Top with fresh blueberries. Enjoy as a quick and nutritious breakfast or snack."),
            Meal(name: "Beef Chili", imageUrl: "beef_chili", ingredients: "beef, chili, onion, tomato, garlic, kidney beans", instructions: "Brown ground beef in a pot over medium heat. Add chopped onions, minced garlic, and diced tomatoes. Stir in chili powder and cook until fragrant. Add drained kidney beans and enough water or broth to cover. Simmer for at least 30 minutes, stirring occasionally. Adjust seasoning with salt and pepper. Serve hot with optional toppings like shredded cheese and chopped onions."),
            Meal(name: "Potato Mussel Soup", imageUrl: "potato_mussel_soup", ingredients: "potato, mussel, onion, garlic, butter, milk", instructions: "Saute chopped onions and minced garlic in butter until softened. Add diced potatoes and cover with milk. Simmer until potatoes are tender. Add cleaned mussels and cook until they open. Discard any unopened mussels. Season with salt and pepper to taste. Serve hot with crusty bread."),
            Meal(name: "Cheese-Stuffed Mushrooms", imageUrl: "cheese_stuffed_mushrooms", ingredients: "mushroom, cheese, garlic, parsley, olive oil", instructions: "Remove stems from mushrooms and brush caps with olive oil. Mix grated cheese with minced garlic and chopped parsley. Stuff each mushroom cap with the cheese mixture. Bake in a preheated oven at 375°F (190°C) for 15-20 minutes until cheese is melted and bubbly. Serve hot as an appetizer or side dish."),
            Meal(name: "Shrimp Pasta", imageUrl: "shrimp_pasta", ingredients: "shrimp, pasta, garlic, lemon, butter, parsley", instructions: "Cook pasta according to package instructions. While pasta is cooking, heat butter in a skillet over medium heat. Add minced garlic and cook until fragrant. Add cleaned shrimp to the skillet and cook until pink and opaque. Squeeze lemon juice over the shrimp and season with salt and pepper. Toss cooked pasta with the shrimp and butter sauce. Garnish with chopped parsley before serving."),
            Meal(name: "Apple Carrot Salad", imageUrl: "apple_carrot_salad", ingredients: "apple, carrot, lemon, cucumber, olive oil", instructions: "Julienne apples, carrots, and cucumbers. Toss them together in a bowl. Squeeze lemon juice over the salad and drizzle with olive oil. Season with salt and pepper. Toss again to combine. Serve chilled as a refreshing side dish."),
            Meal(name: "Corn Cheese Fritters", imageUrl: "corn_cheese_fritters", ingredients: "corn, cheese, egg, flour, salt, pepper", instructions: "Mix corn kernels, grated cheese, beaten eggs, flour, salt, and pepper in a bowl to form a thick batter. Heat oil in a pan over medium heat. Drop spoonfuls of the batter into the hot oil and fry until golden brown and crispy on both sides. Drain on paper towels. Serve hot as a tasty snack."),
            Meal(name: "Avocado Mozzarella Salad", imageUrl: "avocado_mozzarella_salad", ingredients: "avocado, mozzarella cheese, tomato, basil, olive oil", instructions: "Slice avocado, mozzarella cheese, and tomatoes. Arrange them on a plate alternating slices. Drizzle with olive oil and sprinkle chopped fresh basil on top. Season with salt and pepper. Serve as a light and flavorful salad."),
            Meal(name: "Yogurt Strawberry Parfait", imageUrl: "yogurt_strawberry_parfait", ingredients: "yogurt, strawberry, granola, honey", instructions: "Layer yogurt, sliced strawberries, and granola in a glass or bowl. Drizzle honey over each layer. Repeat the layers until the glass is filled. Garnish with a strawberry on top. Serve chilled as a delicious and healthy dessert."),
            Meal(name: "Broccoli Cheese Soup", imageUrl: "broccoli_cheese_soup", ingredients: "broccoli, cheese, onion, garlic, milk, butter", instructions: "Saute chopped onions and minced garlic in butter until translucent. Add chopped broccoli florets and cook until slightly tender. Pour in milk and bring to a simmer. Add grated cheese and stir until melted and smooth. Season with salt and pepper. Blend the soup until creamy using an immersion blender or regular blender. Serve hot with crusty bread."),

        ]
    }
    
    func handleUploadPhoto() {
        // Implement logic to handle photo upload (set hasIngredients to true after successful upload)
//        hasIngredients = true // Placeholder logic, replace with your actual implementation
        filterMeals()
    }
}

