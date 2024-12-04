//
//  Cocktail.swift
//  CocktailBook
//
//  Created by mahesh kolagatla on 25/11/24.
//

import Foundation

class CocktailModel: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let shortDescription: String
    let longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
    
    init(id: String, name: String, type: String, shortDescription: String, longDescription: String, preparationMinutes: Int, imageName: String, ingredients: [String]) {
        self.id = id
        self.name = name
        self.type = type
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.preparationMinutes = preparationMinutes
        self.imageName = imageName
        self.ingredients = ingredients
    }
}
enum CocktailType: String, CaseIterable {
    case alcoholic = "Alcoholic"
    case nonAlcoholic = "Non-Alcoholic"
    case all = "All"
}
