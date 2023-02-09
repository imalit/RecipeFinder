//
//  HeaderView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-09.
//

import SwiftUI

struct HeaderView<ViewModel>: View where ViewModel: RecipePageViewModel {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            AsyncImage(
                url: URL(string: viewModel.recipe.image ?? ""),
                content: { image in
                    image.resizable()
                        .scaledToFill()
                }, placeholder: {
                    Color.white
                }
            )
            .mask(
                LinearGradient(colors: [.white, .white, .clear], startPoint: .top, endPoint: .bottom)
            )
            .position(
                x: Constants.ScreenSize.midX,
                y: Constants.ScreenSize.height * 0.1
            )
            .frame(width: Constants.ScreenSize.width)
            
            GeometryReader { reader in
                VStack (spacing: 10) {
                    StrokeTextView(
                        text: viewModel.recipe.title ?? "",
                        width: 0.80
                    )
                    .multilineTextAlignment(.center)
                    .font(.system(size:36, weight: .bold))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.4)
                    .padding([.top, .bottom], 20)
                    .padding([.leading, .trailing])
                    .position(
                        x: reader.frame(in: .local).midX,
                        y: reader.frame(in: .local).midY
                    )
                    
                RecipeDataBarView(viewModel: viewModel)
                    .padding([.leading, .trailing])
                }
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let recipe = Recipe(
            id: 100,
            title: "Meyer Lemon Ricotta Pancakes with Blackberry Compote",
            image: "https://spoonacular.com/recipeImages/651765-556x370.jpg"
        )
        let viewModel = RecipePageViewModelImp(recipe: recipe)
        HeaderView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
    }
}
