//
//  SearchViewModel.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-02.
//

import Foundation
import Combine

protocol SearchViewModel: ObservableObject {
    var recipesHome: [Recipe] { get set }
    var recipesAll: [Recipe] { get set }
    var selectedRecipe: Recipe? { get set }
    func fetchRecipes(searchTerms: String?)
    
    associatedtype ViewModel: RecipePageViewModel
    func navigateToRecipe(recipe: Recipe) -> RecipePageView<ViewModel>
}

class SearchViewModelImp: SearchViewModel {
    @Published var recipesHome: [Recipe] = []
    @Published var recipesAll: [Recipe] = []
    
    var selectedRecipe: Recipe?
    var cancellable: AnyCancellable?
    
    private let numRandomRecipes = 50
    
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
            let recipeList = recipes.recipes ?? []
            var resultsList = recipes.results ?? []
            
            resultsList.append(contentsOf: recipeList)
            
            var recipesHomeCount = 0
            for recipe in resultsList {
                self.recipesAll.append(recipe)
                
                if recipesHomeCount < 10 { // only show 10 recipes in homepage
                    self.recipesHome.append(recipe)
                    recipesHomeCount += 1
                }
            }
        })
    }
    
    func navigateToRecipe(recipe: Recipe) -> RecipePageView<some RecipePageViewModel> {
        let viewModel = RecipePageViewModelImp(recipe: recipe)
        return RecipePageView(viewModel: viewModel)
    }
}

class SearchViewModelSample: SearchViewModel {
    @Published var recipesHome: [Recipe] = []
    var recipesAll: [Recipe] = []
    var selectedRecipe: Recipe?
    
    func fetchRecipes(searchTerms: String?) {
        for i in (0..<10) {
            recipesHome.append(Recipe(
                id: i,
                title: "Meyer Lemon Ricotta Pancakes with Blackberry Compote",
                image: "https://spoonacular.com/recipeImages/651765-556x370.jpg")
            )
        }
    }
    
    func navigateToRecipe(recipe: Recipe) -> RecipePageView<some RecipePageViewModel> {
        let viewModel = RecipePageViewModelImp(recipe: recipe)
        return RecipePageView(viewModel: viewModel)
    }
}
