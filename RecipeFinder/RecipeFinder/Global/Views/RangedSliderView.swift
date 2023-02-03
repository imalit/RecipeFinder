//
//  RangedSliderView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-03.
//

import SwiftUI

struct RangedSliderView: View {
    @State var recipeTime = 10.0
    
    private let width = Constants.ScreenSize.width
    private let height = Constants.ScreenSize.height
    
    var body: some View {
        Slider(
            value: $recipeTime,
            in: 5...120,
            step: 10
        )
        .tint(.red)
        
        Text("Time: \(recipeTime, specifier: "%.0f") min")
            .font(.footnote)
    }
}

struct RangedSliderView_Previews: PreviewProvider {
    static var previews: some View {
        RangedSliderView()
    }
}
