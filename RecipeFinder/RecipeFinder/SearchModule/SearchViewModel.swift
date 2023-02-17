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
    var time: Float { get set }
    var type: String { get set }
    
    func fetchRecipes(urlString: String, recipesService: RecipesService?)
    func formatSearchURL() -> String
    
    associatedtype hStackVM: HStackWrapViewModel
    func getHStackVM(isCuisine: Bool, list: [String]) -> hStackVM
}

class SearchViewModelImp: SearchViewModel {
    @Published var recipesHome: [Recipe] = []
    @Published var recipesAll: [Recipe] = []
    @Published var includedIngredients: String = ""
    @Published var cuisines: String = ""
    @Published var time: Float = 0.0
    @Published var type: String = ""
    
    var selectedRecipe: Recipe?
    var cancellable: AnyCancellable?
    
    private let numRandomRecipes = 50
    
    func fetchRecipes(urlString: String, recipesService: RecipesService?) {
        
        var recipeService: RecipesService = RecipesServiceImp()
        if let recipesService = recipesService {
            recipeService = recipesService
        }
        
        cancellable = recipeService.fetchRecipes(
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
    
    func formatSearchURL() -> String {
        var searchString = ""
        
        if !includedIngredients.isEmpty {
            let searchTerms = includedIngredients.split(separator: /(, )|,/ )
            
            let query = searchTerms.reduce(into: "") { result, char in
                return result = char == "" ? result : result + "\(char),"
            }
            searchString = "\(searchString)includeIngredients=\(query)"
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
        
        if time >= 5 {
            searchString = "\(searchString)maxReadyTime=\(Int(time))&"
        }
        
        if !searchString.isEmpty {
            searchString.removeLast() //removing last & character
        }
        
        var urlString = searchString.isEmpty ?
            Constants.RecipeService.random :
            Constants.RecipeService.complex
        
        if searchString.isEmpty {
            urlString += "?number=\(numRandomRecipes)&\(Constants.RecipeService.apiKey)"
        } else {
            urlString += "?\(searchString)&\(Constants.RecipeService.apiKey)"
        }
        
        return urlString
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
            tapItem: { [weak self] dict in
                var suffix = ""
                for (key, value) in dict where value == true {
                    suffix = suffix.isEmpty ? key : "\(suffix),\(key)"
                }
                
                if isCuisine {
                    self?.cuisines = suffix
                } else {
                    self?.type = suffix
                }
                
                self?.fetchRecipes(
                    urlString: self?.formatSearchURL() ?? "",
                    recipesService: nil
                )
            }
        )
        return viewModel
    }
}
