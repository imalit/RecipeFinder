//
//  TitlePromptView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-03.
//

import SwiftUI

struct TitlePromptView: View {
    
    var title: String
    
    private let width = Constants.ScreenSize.width
    
    var body: some View {
        Text("\(title)")
            .font(.headline)
            .frame(
                width: width - 10,
                height: 25,
                alignment: .leading
            )
            .foregroundColor(.red)
    }
}

struct TitlePromptView_Previews: PreviewProvider {
    static var previews: some View {
        TitlePromptView(title: "Enter Ingredients:")
    }
}
