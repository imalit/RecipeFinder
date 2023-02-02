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
}

class RecipeCellViewModelImp: RecipeCellViewModel {
    @Published var title: String = ""
    @Published var image: URL?
    
    init(title: String, image: String) {
        self.title = title
        self.image = URL(string: image)
    }
}
