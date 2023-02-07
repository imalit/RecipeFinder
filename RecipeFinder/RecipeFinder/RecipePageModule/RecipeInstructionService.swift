//
//  RecipeInstructionService.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-06.
//

import Foundation
import Combine

struct Steps: Codable {
    var steps: [Step]
}

struct Step: Codable {
    var ingredients: [Ingredient]
    var number: Int
    var step: String
}

struct Ingredient: Codable, Equatable {
    var name: String
    var id: Int
    
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
}

protocol RecipeInstructionService {
    func fetchInstructions(urlString: String) -> AnyPublisher<[Steps], Error>
}

class RecipeInstructionServiceImp: RecipeInstructionService {
    func fetchInstructions(urlString: String) -> AnyPublisher<[Steps], Error> {
        guard let url = URL(string: urlString) else {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: [Steps].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    

}
