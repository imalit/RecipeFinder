//
//  SearchView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-01.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    var cancellable: AnyCancellable?
    
    func fetchRecipes() {
        cancellable = RecipesServiceImp().fetchRecipes(
            urlString: Constants.RecipeService.randomRecipes
        )
        .print("fetching:")
        .sink(receiveCompletion: { _ in }, receiveValue: { recipes in
            var recipeList = recipes.results ?? []
            var resultsList = recipes.results ?? []
            
            resultsList.append(contentsOf: recipeList)
            
            for recipe in resultsList {
                print(recipe)
            }
        })
    }
}

struct SearchView: View {
    
    @StateObject var searchVM = SearchViewModel()
    
    @State var textInput: String = ""
    @State var isPresented = false
    
    var body: some View {
        List {
            TextField("Search", text: $textInput)
            ForEach(0..<10) { i in
                Text("\(i)")
                    .onTapGesture {
                        isPresented = true
                    }
            }
            .sheet(isPresented: $isPresented, content: {
                RecipeView()
            })
        }.onAppear {
            searchVM.fetchRecipes()
        }
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
