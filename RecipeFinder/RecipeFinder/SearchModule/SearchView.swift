//
//  SearchView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-01.
//

import SwiftUI

struct SearchView<SearchVM: SearchViewModel, NavigateVM: Navigation>: View {
    
    @StateObject var searchVM: SearchVM
    @StateObject var navigateVM: NavigateVM
    
    @State var isRecipePresented = false
    @State var isViewAllPresented = false
    
    private let width = Constants.ScreenSize.width
    private let height = Constants.ScreenSize.height
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Search Recipes")
                    .font(.headline)
                    .frame(width: 500, height: 50)
                    .background(.red)
                    .foregroundColor(.white)
                
                TextAreaView(viewModel: searchVM)

                VStack {
                    Slider(value: $searchVM.time, in: 0...180, step: 5) { isEditing in
                        if !isEditing {
                            searchVM.formatSearchURL()
                        }
                    }
                        .accentColor(Color.red)
                    Text("Max Time: \(searchVM.time, specifier: "%0.f") min")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                .padding([.horizontal], 20)
                
                TitlePromptView(title: "Choose meal type:")
                HStackWrapView(
                    hStackWrapVM: searchVM.getHStackVM(
                        isCuisine: false,
                        list: ["Main Course", "Dessert", "Snack", "Breakfast"]
                    )
                )
                .frame(height: width/10)
                
                TitlePromptView(title: "Choose cuisine type:")
                    .padding(0)
                HStackWrapView(
                    hStackWrapVM: searchVM.getHStackVM(
                        isCuisine: true,
                        list: ["Chinese", "Japanese", "Italian", "Korean", "American", "French"]
                    )
                )
                .padding([.bottom], 10)
                
                HStack {
                    Text("Top Recipes")
                        .font(.headline)
                        .foregroundColor(.red)
                    Spacer()
                    Button("See all") {
                        self.isViewAllPresented = true
                    }
                        .font(.body)
                        .foregroundColor(.red)
                        .navigationDestination(
                            isPresented: $isViewAllPresented,
                            destination: {
                                let seeAllVM = SeeAllViewModel(recipes: searchVM.recipesAll)
                                SeeAllView(
                                    navigateVM: NavigationImp(),
                                    seeAllVM: seeAllVM
                                )
                                .onDisappear {
                                    isViewAllPresented = false
                                }
                            }
                        )
                }
                .frame(width: width-20, height: 30)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(searchVM.recipesHome) { recipe in
                            let recipeCellVM = RecipeCellViewModelImp(
                                recipe: recipe,
                                isTapped: { recipe in
                                    searchVM.selectedRecipe = recipe
                                }
                            )
                            RecipeCellView(viewModel: recipeCellVM, isTapped: $isRecipePresented)
                        }
                        .sheet(
                            isPresented: $isRecipePresented,
                            onDismiss: {
                                isRecipePresented = false
                            }, content: {
                                if let recipe = searchVM.selectedRecipe {
                                    navigateVM.navigateToRecipe(recipe: recipe)
                                }
                            }
                        )
                    }
                    .padding([.leading, .trailing], 5)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                searchVM.fetchRecipes(searchTerms: nil)
            }
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        let searchVM = SearchViewModelSample()
//        SearchView(searchVM: searchVM)
//    }
//}
