//
//  RecipeCellViewModel.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-02.
//

import Foundation

protocol RecipeCellViewModel: ObservableObject {
    var title: String { get set }
    var image: URL? { get set }
    func isTileTapped()
}

class RecipeCellViewModelImp: RecipeCellViewModel {
    @Published var title: String = ""
    @Published var image: URL?
    
    private var isTapped: ((Recipe)->())? = nil
    private var recipe: Recipe? = nil
    
    init(recipe: Recipe?, isTapped: ((Recipe)->())?) {
        self.title = recipe?.title ?? ""
        
        if let image = recipe?.image {
            self.image = URL(string: image)
        }
        
        if let recipe = recipe {
            self.recipe = recipe
        }
        
        self.isTapped = isTapped
    }
    
    func isTileTapped() {
        if let recipe = recipe {
            isTapped?(recipe)
        }
    }
}
