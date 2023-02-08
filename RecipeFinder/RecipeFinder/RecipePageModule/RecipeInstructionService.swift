//
//  RecipeInstructionService.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-06.
//

import Foundation
import Combine

struct DetailedRecipe: Codable {
    var extendedIngredients: [Ingredient]?
    var readyInMinutes: Int
    var servings: Int
    var analyzedInstructions: [Steps]?
}

struct Ingredient: Codable, Equatable {
    var id: Int
    var originalName: String
    var measures: Measures?
    
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
}

struct Measures: Codable {
    var us: Amount?
    var metric: Amount?
}

struct Amount: Codable {
    var amount: Float?
    var unitShort: String
}

struct Steps: Codable {
    var steps: [Step]
}

struct Step: Codable {
    var number: Int?
    var step: String?
}

protocol RecipeInstructionService {
    func fetchInstructions(urlString: String) -> AnyPublisher<DetailedRecipe, Error>
}

class RecipeInstructionServiceImp: RecipeInstructionService {
    func fetchInstructions(urlString: String) -> AnyPublisher<DetailedRecipe, Error> {
        guard let url = URL(string: urlString) else {
            let empty = DetailedRecipe(
                extendedIngredients: [],
                readyInMinutes: 0,
                servings: 0,
                analyzedInstructions: []
            )
            
            return Just(empty)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: DetailedRecipe.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
