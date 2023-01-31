//
//  CustomTabBarView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-01-31.
//

import SwiftUI

struct CustomTabBarView: View {
    var body: some View {
        ZStack {
            GeometryReader { reader in
                let width = reader.size.width
                let height = reader.size.height
                
                Circle()
                    .trim(from: 0.55, to: 0.95)
                    .frame(width: width/4)
                    .position(x: reader.frame(in: .local).midX, y: height/3*2)
                Rectangle()
                    .frame(height: height/2)
                    .position(x: reader.frame(in: .local).midX, y: height*0.75)
            }
            .frame(height: 100, alignment: .bottom)
            
            Text("Hello World")
                .foregroundColor(.white)
        }
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView()
            .previewLayout(.sizeThatFits)
    }
}
