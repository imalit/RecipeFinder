//
//  StrokeTextView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-07.
//

import SwiftUI

struct StrokeTextView: View {
    let text: String
    let width: CGFloat
    
    var body: some View {
        ZStack {
            ZStack {
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(.black)
            Text(text)
        }
    }
}

struct StrokeTextView_Previews: PreviewProvider {
    static var previews: some View {
        StrokeTextView(text: "Hello World", width: 0.5)
            .foregroundColor(.white)
    }
}
