//
//  Collection+Extension.swift
//  Movie-List-App
//
//  Created by Doogie on 5/24/24.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
