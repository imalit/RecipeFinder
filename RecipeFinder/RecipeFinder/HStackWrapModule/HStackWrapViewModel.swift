//
//  HStackWrapViewModel.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-09.
//

import SwiftUI

protocol HStackWrapViewModel: ObservableObject {
    var tapItem: ((String)->Void)? { get set }
    var list: [String] { get set }
}

class HStackWrapViewModelImp: HStackWrapViewModel {
    var tapItem: ((String)->Void)?
    var list: [String] = []
    
    init(list: [String], tapItem: ((String) -> Void)?) {
        self.tapItem = tapItem
        self.list = list
    }
}
