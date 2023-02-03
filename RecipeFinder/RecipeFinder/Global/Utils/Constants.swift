//
//  Constants.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-01.
//

import Foundation
import SwiftUI

enum Constants {
    enum RecipeService {
        static let complex = "https://api.spoonacular.com/recipes/complexSearch"
        static let random = "https://api.spoonacular.com/recipes/random"
        static let apiKey = "apiKey=ec3fbdd6616044f6bdda5f523abd9eeb"
    }
    
    enum ScreenSize {
        static let width = UIScreen.main.bounds.size.width
        static let height = UIScreen.main.bounds.size.height
    }
}
