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
                .mask(
                    LinearGradient(colors: [.white, .white, .white, .clear], startPoint: .top, endPoint: .bottom)
                )
                
                VStack {
                    StrokeTextView(
                        text: viewModel.recipe.title ?? "",
                        width: 0.80
                    )
                    .multilineTextAlignment(.center)
                    .font(.system(size:36, weight: .bold))
                    .foregroundColor(.white)
                    
                    HStack {
                        Text("total time: \n \(viewModel.totalTime) min")
                            .lineLimit(2)
                        
                        VStack (spacing: 0) {
                            Text("Servings:")
                            TextField("2", text: $viewModel.servingDesired)
                                .multilineTextAlignment(.trailing)
                        }
                            
                        
                        Toggle(isOn: $viewModel.toggleImperial) {
                            Text("Imperial Units")
                                .multilineTextAlignment(.center)
                        }
                            
                    }
                    .padding([.leading, .trailing])
                }
            }
            .position(
                x: Constants.ScreenSize.midX ,
                y: Constants.ScreenSize.height * 0.15
            )
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.system(size: 12, weight: .light))
                        .padding([.leading])
                    List(viewModel.ingredients, id: \.self) { ingredient in
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
                    List(viewModel.steps, id: \.self) { step in
                        Text("\(step)")
                            .foregroundColor(.black)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .font(.system(size: 12, weight: .regular))
                }
                .padding([.leading], -20)
            }
            .padding([.top], -100)
        }
        .padding([.top], 25)
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
