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
            
            TextAreaView()
            RangedSliderView()
                .frame(width: width - 10)
            
            TitlePromptView(title: "Choose meal type:")
            HStackWrapView(list: ["Breakfast", "Lunch", "Dinner", "Dessert",
                                "Snack"])
            
            TitlePromptView(title: "Choose cuisine type:")
            HStackWrapView(list: ["Chinese", "Japanese", "Korean", "American", "French", "Italian"])
            
            
            Text("Top Recipes")
                .font(.headline)
                .frame(width: 500, height: 30)
                .foregroundColor(.red)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(searchVM.recipes) { recipe in
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
                                isPresented = true
                            }
                    }
                    .sheet(isPresented: $isPresented, content: {
                        RecipeView()
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let searchVM = SearchViewModelSample()
        SearchView(searchVM: searchVM)
    }
}
