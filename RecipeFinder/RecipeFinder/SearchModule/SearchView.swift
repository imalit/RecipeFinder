//
//  SearchView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-01.
//

import SwiftUI

struct SearchView<ViewModel>: View where ViewModel: SearchViewModel {
    
    @StateObject var searchVM: ViewModel
    @State var isPresented = false
    
    private let width = Constants.ScreenSize.width
    private let height = Constants.ScreenSize.height
    
    var body: some View {
        VStack {
            Text("Search Recipes")
                .font(.headline)
                .frame(width: 500, height: 50)
                .background(.red)
                .foregroundColor(.white)
            
            TextAreaView(viewModel: searchVM)
            RangedSliderView(viewModel:
                RangedSliderViewModelImp(
                    sliderPosition: 0...15,
                    sliderBounds: 0...120
                ), sliderPositionChanged: { _ in }
            )
            .padding([.top, .bottom], 20)
            
            TitlePromptView(title: "Choose meal type:")
            HStackWrapView(
                hStackWrapVM: searchVM.getHStackVM(
                    list: ["Main Course", "Dessert", "Snack", "Breakfast"],
                    isCuisine: false
                )
            )
            .frame(height: width/10)
            
            TitlePromptView(title: "Choose cuisine type:")
                .padding(0)
            HStackWrapView(
                hStackWrapVM: searchVM.getHStackVM(
                    list: ["Chinese", "Japanese", "Italian", "Korean", "American", "French"],
                    isCuisine: true
                )
            )
                .padding([.bottom], 10)
            
            HStack {
                Text("Top Recipes")
                    .font(.headline)
                    .foregroundColor(.red)
                Spacer()
                Text("See all")
                    .font(.body)
                    .foregroundColor(.red)
            }
            .frame(width: width-20, height: 30)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(searchVM.recipesHome) { recipe in
                        let recipeCellVM = RecipeCellViewModelImp(
                            title: recipe.title,
                            image: recipe.image
                        )
                        RecipeCellView(viewModel: recipeCellVM)
                            .padding(5)
                            .background(Color.red)
                            .cornerRadius(5)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                searchVM.selectedRecipe = recipe
                                isPresented = true
                            }
                    }
                    .sheet(
                        isPresented: $isPresented,
                        onDismiss: {
                            isPresented = false
                        }, content: {
                            if let recipe = searchVM.selectedRecipe {
                                searchVM.navigateToRecipe(recipe: recipe)
                            }
                    })
                }
                .padding([.leading, .trailing], 5)
            }
        }
        .onAppear {
            searchVM.fetchRecipes(searchTerms: nil)
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        let searchVM = SearchViewModelSample()
//        SearchView(searchVM: searchVM)
//    }
//}
