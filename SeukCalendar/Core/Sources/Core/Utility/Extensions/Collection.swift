//
//  Collection+Safe.swift
//  Core
//
//  Created by yongbeomkwak on 10/7/25.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
