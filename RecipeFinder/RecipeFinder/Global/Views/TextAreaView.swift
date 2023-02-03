//
//  TextAreaView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-03.
//

import SwiftUI

struct TextAreaView: View {
    @State var textInput: String = ""
    
    private let width = Constants.ScreenSize.width
    private let height = Constants.ScreenSize.height
    
    var body: some View {
        TitlePromptView(title: "Enter Ingredients:")
        
        TextEditor(text: $textInput)
            .frame(width: width - 10, height: height/10)
            .border(.red)
    }
}

struct TextAreaView_Previews: PreviewProvider {
    static var previews: some View {
        TextAreaView()
    }
}
