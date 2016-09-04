//
//  Synchronizable.swift
//  Synchronizable
//
//  Created by Romain Pouclet on 2016-09-04.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation

protocol Identifiable {
    var identifier: String { get }

}

extension Identifiable {
    func isEqual(to identifiable: Identifiable) -> Bool {
        return identifier == identifiable.identifier
    }
}

protocol Synchronizable: Identifiable {
    func compare(against persistable: Persistable) -> Diff
}

protocol Persistable: Identifiable {

}

enum Diff {
    case Insert(Synchronizable)
    case Update(Synchronizable)
    case Delete(identifier: String)
}

extension Diff {

    static func reducer(local persistables: [Persistable], remote synchronizables: [Synchronizable]) -> [Diff] {
        let persistedIdentifiers = persistables.map { $0.identifier }

        return synchronizables
            .map {
                if !persistedIdentifiers.contains($0.identifier) {
                    return .Insert($0)
                }

                return .Delete(identifier: "lol")
            }
    }
}