//
//  RecipeCellView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-02.
//

import SwiftUI

struct RecipeCellView<ViewModel>: View where ViewModel: RecipeCellViewModel{
    
    @StateObject var viewModel: ViewModel
    
    let width = Constants.ScreenSize.width
    let height = Constants.ScreenSize.height
    
    var body: some View {
        ZStack {
            AsyncImage(
                url: viewModel.image,
                content: { image in
                    image.resizable()
                        .scaledToFit()
                }, placeholder: {
                    Color.white
                }
            )
            .frame(width: width*0.37, height: width*0.25)
            .cornerRadius(10)
            
            StrokeText(text: viewModel.title, width: 0.80)
                .multilineTextAlignment(.center)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: width*0.37, height: width*0.25)
        }        
    }
}

struct StrokeText: View {
    let text: String
    let width: CGFloat
    
    var body: some View {
        ZStack {
            ZStack {
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(.black)
            Text(text)
        }
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
