//
//  SearchViewModel.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-02.
//

import Foundation
import Combine

protocol SearchViewModel: ObservableObject {
    var recipes: [Recipe] { get set }
    func fetchRecipes(searchTerms: String?)
}

class SearchViewModelImp: SearchViewModel {
    @Published var recipes: [Recipe] = []
    var cancellable: AnyCancellable?
    
    private let numRandomRecipes = 10
    
    func fetchRecipes(searchTerms: String? = nil) {

        var urlString = searchTerms == nil ?
            Constants.RecipeService.random :
            Constants.RecipeService.complex
        
        if searchTerms == nil {
            urlString += "?number=\(numRandomRecipes)&\(Constants.RecipeService.apiKey)"
        } else if let searchTerms = searchTerms {
            urlString += "?\(searchTerms)&\(Constants.RecipeService.apiKey)"
        }
        
        cancellable = RecipesServiceImp().fetchRecipes(
            urlString: urlString
        )
        .sink(receiveCompletion: { _ in }, receiveValue: { recipes in
            var recipeList = recipes.recipes ?? []
            var resultsList = recipes.results ?? []
            
            resultsList.append(contentsOf: recipeList)
            
            for recipe in resultsList {
                self.recipes.append(recipe)
            }
        })
    }
}
