//
//  SearchViewModel.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-02.
//

import Foundation
import Combine
import SwiftUI

protocol Navigation: ObservableObject {
    associatedtype ViewModel: RecipePageViewModel
    func navigateToRecipe(recipe: Recipe) -> RecipePageView<ViewModel>
}

class NavigationImp: Navigation {
    func navigateToRecipe(recipe: Recipe) -> RecipePageView<some RecipePageViewModel> {
        let viewModel = RecipePageViewModelImp(recipe: recipe)
        return RecipePageView(recipePageVM: viewModel)
    }
}

protocol SearchViewModel: ObservableObject {
    var recipesHome: [Recipe] { get set }
    var recipesAll: [Recipe] { get set }
    var selectedRecipe: Recipe? { get set }
    var includedIngredients: String { get set }
    var cuisines: String { get set }
    var time: Int? { get set }
    var type: String { get set }
    
    func fetchRecipes(searchTerms: String?)
    func formatSearchURL()
    
//    associatedtype ViewModel: RecipePageViewModel
//    func navigateToRecipe(recipe: Recipe) -> RecipePageView<ViewModel>
    
    associatedtype hStackVM: HStackWrapViewModel
    func getHStackVM(isCuisine: Bool, list: [String]) -> hStackVM
}

class SearchViewModelImp: SearchViewModel {
    @Published var recipesHome: [Recipe] = []
    @Published var recipesAll: [Recipe] = []
    @Published var includedIngredients: String = ""
    @Published var cuisines: String = ""
    @Published var time: Int? = nil
    @Published var type: String = ""
    
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
            self.recipesAll = []
            self.recipesHome = []
            
            for recipe in resultsList {
                self.recipesAll.append(recipe)
                
                if recipesHomeCount < 10 { // only show 10 recipes in homepage
                    self.recipesHome.append(recipe)
                    recipesHomeCount += 1
                }
            }
        })
    }
    
//    func navigateToRecipe(recipe: Recipe) -> RecipePageView<some RecipePageViewModel> {
//        let viewModel = RecipePageViewModelImp(recipe: recipe)
//        return RecipePageView(recipePageVM: viewModel)
//    }
    
    func formatSearchURL() {
        var searchString = ""
        
        if !includedIngredients.isEmpty {
            searchString = "\(searchString)includeIngredients=\(includedIngredients)"
            if searchString.last == "," {
                searchString.removeLast()
            }
            searchString = "\(searchString)&"
        }
        
        if !cuisines.isEmpty {
            searchString = "\(searchString)cuisine=\(cuisines)&"
        }
        
        if !type.isEmpty {
            searchString = "\(searchString)type=\(type)&"
        }
        
        if let time = time {
            searchString = "\(searchString)maxReadyTime=\(time)&"
        }
        
        if !searchString.isEmpty {
            searchString.removeLast() //removing last & character
        }
        
        fetchRecipes(searchTerms: searchString)
    }
    
    func getHStackVM(isCuisine: Bool, list: [String]) -> some HStackWrapViewModel {
        
        for item in list {
            if isCuisine {
                FilterState.updateCuisineFilter(item: item)
            } else {
                FilterState.updateMealTypeFilter(item: item)
            }
        }
        
        let viewModel = HStackWrapViewModelImp(
            isCuisine: isCuisine,
            tapItem: { dict in
                var suffix = ""
                for (key, value) in dict where value == true {
                    suffix = suffix.isEmpty ? key : "\(suffix), \(key)"
                }
                
                if isCuisine {
                    self.cuisines = suffix
                } else {
                    self.type = suffix
                }
                
                self.formatSearchURL()
            }
        )
        return viewModel
    }
}

//class SearchViewModelSample: SearchViewModel {
//    @Published var recipesHome: [Recipe] = []
//    var recipesAll: [Recipe] = []
//    var selectedRecipe: Recipe?
//    var includedIngredients: String?
//    var cuisines: String?
//    var time: Int?
//    var type: String?
//
//    func fetchRecipes(searchTerms: String?) {
//        for i in (0..<10) {
//            recipesHome.append(Recipe(
//                id: i,
//                title: "Meyer Lemon Ricotta Pancakes with Blackberry Compote",
//                image: "https://spoonacular.com/recipeImages/651765-556x370.jpg")
//            )
//        }
//    }
//
//    func navigateToRecipe(recipe: Recipe) -> RecipePageView<some RecipePageViewModel> {
//        let viewModel = RecipePageViewModelImp(recipe: recipe)
//        return RecipePageView(recipePageVM: viewModel)
//    }
//
//    func saveText(text: String) { }
//    func formatSearchURL() { }
//
//}
