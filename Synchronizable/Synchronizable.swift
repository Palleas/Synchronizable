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

protocol SynchronizableType: Identifiable {
    func compare(against persistable: Persistable) -> Diff
}

protocol Synchronizable: SynchronizableType {
    associatedtype PersistedType: Persistable

    func comparison(against persistable: PersistedType) -> Diff
}

extension Synchronizable {
    func compare(against persistable: Persistable) -> Diff {
        guard let compared = persistable as? PersistedType else { return .None }

        return comparison(against: compared)
    }
}

protocol Persistable: Identifiable {

}

enum Diff {
    case Insert(SynchronizableType)
    case Update(SynchronizableType)
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

    static func reducer(local persistables: [Persistable], remote synchronizables: [SynchronizableType]) -> [Diff] {
        let persistedIds = Set(persistables.map { $0.identifier })
        let synchronizedIds = Set(synchronizables.map { $0.identifier })

        let deleted: [Diff] = persistedIds.subtract(synchronizedIds).map { .Delete(identifier: $0) }

        return deleted + synchronizables
            .map { synchronized in
                if !persistedIds.contains(synchronized.identifier) {
                    return .Insert(synchronized)
                }

                if let persisted = persistables.filter({ synchronized.isEqual(to: $0) }).first {
                    return synchronized.compare(against: persisted)
                }

                return .None
            }
    }
}
