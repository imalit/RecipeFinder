//
//  HStackWrapViewModel.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-09.
//

import SwiftUI

protocol HStackWrapViewModel: ObservableObject {
    var switchToggles: [String: Bool] { get set }
    var isCuisine: Bool { get set }
    func isItemTapped(item: String)
}

class HStackWrapViewModelImp: HStackWrapViewModel {
    @Published var switchToggles: [String:Bool] = [:]
    var tapItem: (([String:Bool])->Void)?
    var isCuisine = false
    
    init(isCuisine: Bool = false, tapItem: (([String:Bool]) -> Void)? = nil) {
        self.tapItem = tapItem
        self.isCuisine = isCuisine
        self.switchToggles = isCuisine ? FilterState.cuisineFilter : FilterState.mealTypeFilter
    }
    
    func isItemTapped(item: String) {
        if !isCuisine {
            for (key, _) in switchToggles {
                if key == item {
                    switchToggles[key]?.toggle()
                    FilterState.mealTypeFilter[key]?.toggle()
                } else {
                    switchToggles[key] = false
                    FilterState.mealTypeFilter[key] = false
                }
            }
        } else {
            switchToggles[item]?.toggle()
            FilterState.cuisineFilter[item]?.toggle()
        }
        
        tapItem?(switchToggles)
    }
}
