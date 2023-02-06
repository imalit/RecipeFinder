//
//  RecipePageViewModel.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-06.
//

import Foundation
import Combine

protocol RecipePageViewModel: ObservableObject {
    var recipe: Recipe { get set }
    func fetchInstructions()
}

class RecipePageViewModelImp: RecipePageViewModel {
    var recipe: Recipe
    
    private var anyCancellable: AnyCancellable?
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func fetchInstructions() {
        
        let urlString = Constants.RecipeService.instructions(id: recipe.id) + "?" +
            Constants.RecipeService.apiKey
        
        anyCancellable = RecipeInstructionServiceImp()
            .fetchInstructions(urlString: urlString)
            .sink(receiveCompletion: { _ in }, receiveValue: { steps in
                for step in steps {
                    print(step)
                }
            }
        )
    }
}
