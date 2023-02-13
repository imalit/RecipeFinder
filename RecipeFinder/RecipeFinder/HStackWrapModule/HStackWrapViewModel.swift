//
//  HStackWrapViewModel.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-09.
//

import SwiftUI

protocol HStackWrapViewModel: ObservableObject {
    var list: [String] { get set }
    var switchToggles: [String:Bool] { get set }
    var isCuisine: Bool { get set }
    func isItemTapped(item: String)
}

class HStackWrapViewModelImp: HStackWrapViewModel {
    @Published var switchToggles: [String:Bool] = [:]
    var tapItem: (([String:Bool])->Void)?
    var list: [String] = []
    var isCuisine = false
    
    init(isCuisine: Bool = false, list: [String] = [], tapItem: (([String:Bool]) -> Void)? = nil) {
        self.tapItem = tapItem
        self.list = list
        self.isCuisine = isCuisine
        
        for item in list {
            switchToggles[item] = false
        }
    }
    
    func isItemTapped(item: String) {
        if !isCuisine {
            for (key, _) in switchToggles {
                if key == item {
                    switchToggles[key]?.toggle()
                } else {
                    switchToggles[key] = false
                }
            }
        } else {
            switchToggles[item]?.toggle()
        }
        
        tapItem?(switchToggles)
    }
}
