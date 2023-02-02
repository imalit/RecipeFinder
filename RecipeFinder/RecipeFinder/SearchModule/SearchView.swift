//
//  SearchView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-01.
//

import SwiftUI

struct SearchView<ViewModel>: View where ViewModel: SearchViewModel {
    
    @StateObject var searchVM: ViewModel
    
    @State var textInput: String = ""
    @State var isPresented = false
    
    var body: some View {
        VStack {
            Text("Recipe Feed")
                .font(.headline)
                .frame(width: 500, height: 50)
                .background(.red)
                .foregroundColor(.white)
            List(searchVM.recipes) { recipe in
                let recipeCellVM = RecipeCellViewModelImp(
                    title: recipe.title,
                    image: recipe.image
                )
                RecipeCellView(viewModel: recipeCellVM)
                    .padding([.leading], 15)
                    .padding([.top, .bottom], 2)
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
            .listStyle(.plain)
        }
        .onAppear {
            searchVM.fetchRecipes(searchTerms: nil)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let searchVM = SearchViewModelImp()
        SearchView(searchVM: searchVM)
    }
}
