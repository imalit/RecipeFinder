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
        VStack {
            ZStack {
                AsyncImage(
                    url: URL(string: viewModel.recipe.image ?? ""),
                    content: { image in
                        image.resizable()
                            .scaledToFit()
                    }, placeholder: {
                        Color.white
                    }
                )
                .frame(width: Constants.ScreenSize.width)
                
                StrokeText(
                    text: viewModel.recipe.title ?? "",
                    width: 0.80
                )
                .multilineTextAlignment(.center)
                .font(.system(size:36, weight: .bold))
                .foregroundColor(.white)
            }
            Spacer()
            HStack (spacing: 10){
                VStack {
                    List(viewModel.ingredients, id: \.id) { ingredient in
                        Text("\(ingredient.name)")
                            .foregroundColor(.black)
                            .font(.system(size: 12, weight: .light))
                    }
                    .listStyle(.plain)
                }
                VStack {
                    List(viewModel.steps, id: \.self) { step in
                        Text("\(step)")
                            .foregroundColor(.black)
                    }
                    .listStyle(.plain)
                    .font(.system(size: 12, weight: .regular))
                }
            }
        }
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
            .previewLayout(.sizeThatFits)
    }
}
