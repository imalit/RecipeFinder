//
//  RecipeCellView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-02.
//

import SwiftUI

struct RecipeCellView<ViewModel>: View where ViewModel: RecipeCellViewModel{
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            HStack {
                AsyncImage(
                    url: viewModel.image,
                    content: { image in
                        image.resizable()
                            .scaledToFit()
                    }, placeholder: {
                        Color.white
                    }
                )
                .frame(width: 150, height: 100)
                .cornerRadius(5)
                Spacer()
                Text("\(viewModel.title)")
                    .multilineTextAlignment(.trailing)
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(20)
                    
            }

        }
        .frame(minWidth: 0 , maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        
    }
}

struct RecipeCellView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RecipeCellViewModelImp(
            title: "Meyer Lemon Ricotta Pancakes with Blackberry Compote",
            image: "https://spoonacular.com/recipeImages/651765-556x370.jpg"
        )
        
        RecipeCellView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
    }
}
