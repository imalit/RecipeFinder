//
//  RecipeView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-01.
//

import SwiftUI

struct RecipePageView<ViewModel>: View where ViewModel: RecipePageViewModel {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        Text("Recipe Details")
            .onAppear {
                viewModel.fetchInstructions()
            }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let recipe = Recipe(
            id: 100,
            title: "Meyer Lemon Ricotta Pancakes with Blackberry Compote",
            image: "https://spoonacular.com/recipeImages/651765-556x370.jpg"
        )
        let viewModel = RecipePageViewModelImp(recipe: recipe)
        RecipePageView(viewModel: viewModel)
    }
}
