//
//  SwiftUIView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-14.
//

import SwiftUI

class SeeAllViewModel: ObservableObject {
    var recipes: [Recipe]
    var selectedRecipe: Recipe? = nil
    
    init(recipes: [Recipe]) {
        self.recipes = recipes
    }
}

struct SeeAllView<SeeAllVM: SeeAllViewModel, NavigateVM: Navigation>: View {
    
    @StateObject var navigateVM: NavigateVM
    @StateObject var seeAllVM: SeeAllVM
    @State var isTapped: Bool = false
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(seeAllVM.recipes) { item in
                let viewModel = RecipeCellViewModelImp(
                    recipe: item,
                    isTapped: { recipe in
                        seeAllVM.selectedRecipe = recipe
                    }
                )
                RecipeCellView(viewModel: viewModel, isTapped: $isTapped)
                .padding()
            }
        }
        .sheet(
            isPresented: $isTapped,
            onDismiss: {
                isTapped = false
            }, content: {
                if let recipe = seeAllVM.selectedRecipe {
                    navigateVM.navigateToRecipe(recipe: recipe)
                }
        })
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeeAllView()
//    }
//}
