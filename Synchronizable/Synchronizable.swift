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
    associatedtype PersistedType: Persistable

    func compare(against persistable: PersistedType) -> Diff<Self>
}

protocol Persistable: Identifiable {

}

enum Diff<S: Synchronizable> {
    case Insert(S)
    case Update(S)
    case Delete(identifier: String)
    case None

    var key: String {
        switch self {
        case .Insert(_): return "Insert"
        case .Update(_): return "Update"
        case .Delete(_): return "Delete"
        case .None: return "None"
        }
    }
}

extension Diff {

    static func reducer<P: Persistable, S: Synchronizable where S.PersistedType == P>(local: [P], remote: [S]) -> [Diff<S>] {
        let persistedIds = Set(local.map { $0.identifier })
        let synchronizedIds = Set(remote.map { $0.identifier })

        let deleted: [Diff<S>] = persistedIds.subtract(synchronizedIds).map { .Delete(identifier: $0) }

        return deleted + remote
            .map { synchronized in
                if !persistedIds.contains(synchronized.identifier) {
                    return .Insert(synchronized)
                }

                if let persisted = local.filter({ synchronized.isEqual(to: $0) }).first {
                    return synchronized.compare(against: persisted)
                }

                return .None
            }
    }
}
