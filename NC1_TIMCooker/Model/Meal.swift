//
//  Meal.swift
//  NC1_TIMCooker
//
//  Created by Eldenabih Tavirazin Lutvie on 01/05/24.
//

import Foundation

struct Meal: Identifiable {
  let id = UUID() // Unique identifier for each meal
  let name: String // Name of the meal
  let imageUrl: String // URL of the meal image
  let ingredients: String // String containing a list of ingredients
  let instructions: String // String containing cooking instructions
}
