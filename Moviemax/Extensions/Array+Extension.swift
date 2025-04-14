//
//  Array+Extension.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
