//
//  ContentView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-01-31.
//

import SwiftUI

struct ContainerView: View {
    
    @State private var selectedTab = 1
    
    var body: some View {
        
        VStack {
            if selectedTab == 0 {
                FoodPairView()
            } else if selectedTab == 1 {
                SearchView(searchVM: SearchViewModelImp())
//                SearchView(searchVM: SearchViewModelSample())
            } else if selectedTab == 2 {
                InfoView()
            }
            Spacer()
        }
        .padding([.bottom], 10)
        .safeAreaInset(edge: .bottom) {
            VStack {
                CustomTabBarView(selectedIndex: $selectedTab)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: 0)
                    .padding([.bottom], 50)
                    .background(.red)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
