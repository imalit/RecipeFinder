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
    var ingredients: [Ingredient] { get set }
    var steps: [String] { get set }
    func fetchInstructions()
}

class RecipePageViewModelImp: RecipePageViewModel {
    @Published var ingredients: [Ingredient] = []
    @Published var steps: [String] = []
    var recipe: Recipe
    
    private var anyCancellable: AnyCancellable?
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func fetchInstructions() {
        guard let id = recipe.id else { return }
        
        let urlString = Constants.RecipeService.instructions(id: id) + "?" +
        Constants.RecipeService.apiKey
        
        var allIngredients: [Ingredient] = []
        var allSteps: [String] = []
        
        anyCancellable = RecipeInstructionServiceImp()
            .fetchInstructions(urlString: urlString)
            .sink(receiveCompletion: { _ in }, receiveValue: { steps in
                let recipeStep = steps[0]
                let steps = recipeStep.steps
                
                for step in steps {
                    allIngredients.append(contentsOf: step.ingredients)
                    allSteps.append("\(step.number). \(step.step)")
                }
                
                self.ingredients = allIngredients.reduce([]) { (result: [Ingredient], ingredient: Ingredient) in
                    if result.contains(ingredient) {
                        return result
                    } else {
                        return result + [ingredient]
                    }
                }
                
                self.steps = allSteps
                
                print(self.ingredients)
                print(self.steps)
            }
        )
    }
}
