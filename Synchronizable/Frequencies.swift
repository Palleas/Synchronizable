//
//  Group.swift
//  Synchronizable
//
//  Created by Romain Pouclet on 2016-09-04.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation

func frequencies<T, V: Hashable>(_ source: [T], predicate: (T) -> V) -> [V: Int] {
    return source
        .map(predicate)
        .reduce([V: Int]()) { acc, key in
            let count = (acc[key] ?? 0) + 1

            var copy = acc
            copy[key] = count

            return copy
        }
}
