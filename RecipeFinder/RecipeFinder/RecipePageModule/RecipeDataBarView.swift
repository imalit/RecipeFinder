//
//  RecipeDataBarView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-09.
//

import SwiftUI

struct RecipeDataBarView<ViewModel>: View where ViewModel: RecipePageViewModel {
    
    @ObservedObject var recipePageVM: ViewModel
    
    var body: some View {
        HStack {
            HStack (spacing: 5) {
                Image(systemName: "clock.fill")
                Text("\(recipePageVM.totalTime) min")
            }
            .padding([.trailing], 20)
            
            HStack (spacing: 10) {
                Image(systemName: "person.3.fill")
                TextField("\(recipePageVM.servingDesired)", text: $recipePageVM.servingDesired)
            }
                
            Picker("Select unit of measurement", selection: $recipePageVM.toggleImperial) {
                Text("Imperial").tag(true)
                Text("Metric").tag(false)
            }
            .pickerStyle(.segmented)
            .padding([.leading], -30)
                
        }
    }
}

struct RecipeDataBarView_Previews: PreviewProvider {
    static var previews: some View {
        let recipe = Recipe(
            id: 100,
            title: "Meyer Lemon Ricotta Pancakes with Blackberry Compote",
            image: "https://spoonacular.com/recipeImages/651765-556x370.jpg"
        )
        let viewModel = RecipePageViewModelImp(recipe: recipe)
        RecipeDataBarView(recipePageVM: viewModel)
            .previewLayout(.sizeThatFits)
    }
}
