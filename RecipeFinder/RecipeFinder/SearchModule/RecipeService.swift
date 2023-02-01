//
//  RecipeService.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-01.
//

import Foundation
import Combine

struct Recipes: Codable {
    var recipes: [Recipe]?
    var results: [Recipe]?
}

struct Recipe: Codable {
    var id: Int
    var title: String
    var image: String
}

protocol RecipesService {
    func fetchRecipes(urlString: String) -> AnyPublisher<Recipes, Error>
}

class RecipesServiceImp: RecipesService {
    func fetchRecipes(urlString: String) -> AnyPublisher<Recipes, Error> {
        guard let url = URL(string: urlString) else {
            return Just(Recipes())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .print("step:")
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: Recipes.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
