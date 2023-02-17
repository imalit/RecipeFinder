//
//  RecipeView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-01.
//

import SwiftUI

struct RecipePageView<ViewModel>: View where ViewModel: RecipePageViewModel {
    
    @StateObject var recipePageVM: ViewModel
    
    var body: some View {
        VStack {
            HeaderView(recipePageVM: recipePageVM)
                .frame(
                    width: Constants.ScreenSize.width,
                    height: Constants.ScreenSize.height * 0.3
                )
                .padding([.bottom], 20)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.system(size: 12, weight: .light))
                        .padding([.leading])
                    List(recipePageVM.ingredients, id: \.self) { ingredient in
                        Text("\(ingredient)")
                            .foregroundColor(.black)
                            .font(.system(size: 10, weight: .light))
                    }
                    .listStyle(.plain)
                }
                .frame(width: 140)
                VStack(alignment: .leading) {
                    Text("Steps")
                        .font(.system(size: 16, weight: .regular))
                        .padding([.leading])
                    List(recipePageVM.steps, id: \.self) { step in
                        Text("\(step)")
                            .foregroundColor(.black)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .font(.system(size: 12, weight: .regular))
                }
                .padding([.leading], -20)
            }
        }
        .padding([.top], 25)
        .onAppear {
            recipePageVM.fetchInstructions(
                urlString: recipePageVM.setUrlString(),
                instructionService: RecipeInstructionServiceImp()
            )
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
        RecipePageView(recipePageVM: viewModel)
            .previewLayout(.sizeThatFits)
    }
}
