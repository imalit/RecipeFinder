//
//  Protocols.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-09.
//

import Combine
import UIKit

protocol FilterStateProtocol {
    static var mealTypeFilter: [String: Bool] { get set }
    static var cuisineFilter: [String: Bool] { get set }
    
    static func updateMealTypeFilter(item: String)
    static func updateCuisineFilter(item: String)
}

struct FilterState: FilterStateProtocol {
    static var mealTypeFilter: [String : Bool] = [:]
    static var cuisineFilter: [String : Bool] = [:]
    
    static func updateMealTypeFilter(item: String) {
        if mealTypeFilter[item] == nil {
            mealTypeFilter[item] = false
        }
    }
    
    static func updateCuisineFilter(item: String) {
        if cuisineFilter[item] == nil {
            cuisineFilter[item] = false
        }
    }
}
