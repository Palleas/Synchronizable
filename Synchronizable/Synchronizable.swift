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
    case insert(S)
    case update(S)
    case delete(identifier: String)
    case none

    var key: String {
        switch self {
        case .insert(_): return "Insert"
        case .update(_): return "Update"
        case .delete(_): return "Delete"
        case .none: return "None"
        }
    }
}

extension Diff {

    static func reducer<P: Persistable, S: Synchronizable>(_ local: [P], remote: [S]) -> [Diff<S>] where S.PersistedType == P {
        let persistedIds = Set(local.map { $0.identifier })
        let synchronizedIds = Set(remote.map { $0.identifier })

        let deleted: [Diff<S>] = persistedIds.subtracting(synchronizedIds).map { .delete(identifier: $0) }

        return deleted + remote
            .map { synchronized in
                if !persistedIds.contains(synchronized.identifier) {
                    return .insert(synchronized)
                }

                if let persisted = local.filter({ synchronized.isEqual(to: $0) }).first {
                    return synchronized.compare(against: persisted)
                }

                return .none
            }
    }
}
