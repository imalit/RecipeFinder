//
//  CustomTabBarView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-01-31.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedIndex: Int
    
    var body: some View {
        ZStack {
            GeometryReader { reader in
                let width = reader.size.width
                let height = reader.size.height
                
                Circle()
                    .trim(from: 0.60, to: 0.90)
                    .frame(width: width/4)
                    .position(x: reader.frame(in: .local).midX, y: height*0.79)
                Rectangle()
                    .frame(height: height/2)
                    .position(x: reader.frame(in: .local).midX, y: height*0.75)
            }
            .frame(height: 100, alignment: .bottom)
            
            HStack {
                
                Button(action: {
                    selectedIndex = 0
                    
                }, label: {
                    Image(systemName: "f.cursive")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                })
                .padding([.leading], 50)
                .padding([.top], 50)
                
                
                Spacer()
                
                Button(action: {
                    selectedIndex = 1
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                })
                .padding([.top], 35)
                
                Spacer()
                
                Button(action: {
                    selectedIndex = 2
                }, label: {
                    Image(systemName: "info")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                })
                .padding([.trailing], 50)
                .padding([.top], 50)
            }
            .frame(height: 100)
            .foregroundColor(.white)
        }
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView(selectedIndex: .constant(1))
            .previewLayout(.sizeThatFits)
    }
}
