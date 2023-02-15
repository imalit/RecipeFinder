//
//  TextAreaView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-03.
//

import SwiftUI

struct TextAreaView<ViewModel>: View where ViewModel: SearchViewModel {
    
    @ObservedObject var viewModel: ViewModel
    @FocusState private var isResponseFocused: Bool
    
    private let width = Constants.ScreenSize.width
    private let height = Constants.ScreenSize.height
    
    var body: some View {
        TitlePromptView(title: "Enter Ingredients:")
        
        TextEditor(text: $viewModel.includedIngredients)
            .frame(width: width - 10, height: height/10)
            .border(.red)
            .submitLabel(.done)
            .focused($isResponseFocused)
            .onChange(of: viewModel.includedIngredients) { _ in
                if let last = viewModel.includedIngredients.last {
                    if last.asciiValue == 10 {
                        isResponseFocused = false
                        viewModel.includedIngredients.removeLast()
                        viewModel.formatSearchURL()
                    } else if last.asciiValue == 44 {
                        viewModel.formatSearchURL()
                    }
                }
            }            
    }
}

//struct TextAreaView_Previews: PreviewProvider {
//    static var previews: some View {
//        let searchVM = SearchViewModelSample()
//        TextAreaView(viewModel: searchVM)
//    }
//}
