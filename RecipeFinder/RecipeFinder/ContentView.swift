//
//  ContentView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-01-31.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            ForEach(0..<10) { i in
                Text("\(i)")
            }
        }.safeAreaInset(edge: .bottom) {
            VStack {
                CustomTabBarView()
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: 0)
                    .padding([.bottom], 30)
                    .background(.red)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
