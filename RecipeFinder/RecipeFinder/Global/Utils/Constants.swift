//
//  Constants.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-01.
//

import Foundation
import SwiftUI
import UIKit

enum Constants {
    enum RecipeService {
        static let complex = "https://api.spoonacular.com/recipes/complexSearch"
        static let random = "https://api.spoonacular.com/recipes/random"
        static let apiKey = "apiKey=ec3fbdd6616044f6bdda5f523abd9eeb"
        
        static func information(id: Int) -> String {
            return "https://api.spoonacular.com/recipes/\(id)/information?\(apiKey)"
        }
    }
    
    enum ScreenSize {
        static let width = UIScreen.main.bounds.size.width
        static let height = UIScreen.main.bounds.size.height
        static let midX = UIScreen.main.bounds.midX
        static let midY = UIScreen.main.bounds.midY
    }
}

extension Color {
    static let inactiveRed = Color.red.opacity(0.5)
}
