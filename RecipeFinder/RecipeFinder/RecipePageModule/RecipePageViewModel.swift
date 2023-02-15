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
    var ingredients: [String] { get set }
    var steps: [String] { get set }
    var toggleImperial: Bool { get set }
    var servingDesired: String { get set }
    var totalTime: Int { get set }
    func fetchInstructions()
    func formatIngredients()
}

class RecipePageViewModelImp: RecipePageViewModel {
    var ingredients: [String] = []
    var steps: [String] = []
    @Published var toggleImperial: Bool = false
    @Published var servingDesired: String = ""
    var totalTime: Int = 0
    var recipe: Recipe
    
    private var anyCancellable: AnyCancellable?
    private var originalIngredients: [Ingredient] = []
    private var originalServings: Int = 0
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func fetchInstructions() {
        guard let id = recipe.id else { return }
        
        let urlString = Constants.RecipeService.information(id: id)

        var allSteps: [String] = []
        
        anyCancellable = RecipeInstructionServiceImp()
            .fetchInstructions(urlString: urlString)
            .sink(receiveCompletion: { _ in }, receiveValue: { recipe in
                
                self.totalTime = recipe.readyInMinutes
                
                if let steps = recipe.analyzedInstructions?.first?.steps {
                    for step in steps {
                        var numString = ""
                        if let number = step.number {
                            numString = String(number)
                        }
                        
                        allSteps.append("\(numString). \(step.step ?? "")")
                    }
                }
                
                self.steps = allSteps
                
                if let extendedIngredients = recipe.extendedIngredients {
                    self.originalIngredients = extendedIngredients
                    self.originalServings = recipe.servings
                    self.servingDesired = String(self.originalServings)
                    self.formatIngredients()
                }
            }
        )
    }
    
    func formatIngredients() {
        var unit = ""
        var ratio: Float = 1.0
        var amount: Float = 0.0
        var allIngredients: [String] = []
        for ingredient in originalIngredients {
            unit = toggleImperial ?
            ingredient.measures?.us?.unitShort ?? "" :
            ingredient.measures?.metric?.unitShort ?? ""
            
            if let servingDesired = Float(servingDesired) {
                ratio = servingDesired/Float(originalServings)
            }
            
            amount = Float(toggleImperial ?
                           ingredient.measures?.us?.amount ?? 0.0 :
                            ingredient.measures?.metric?.amount ?? 0.0) * ratio
            
            allIngredients.append("\(String(format: "%g", amount)) \(unit) \(ingredient.originalName)")
        }
        
        self.ingredients = allIngredients
        
        objectWillChange.send()
    }
}
