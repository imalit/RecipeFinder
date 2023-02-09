//
//  Protocols.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-09.
//

import Combine
import UIKit


/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}
