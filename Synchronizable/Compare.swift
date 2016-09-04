//
//  Compare.swift
//  Synchronizable
//
//  Created by Romain Pouclet on 2016-09-04.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation

typealias IdentifiableRow = (index: Int, identifiable: Identifiable)

func compare (lhs: [Identifiable], _ rhs: [Identifiable]) -> Bool {
    guard lhs.count == rhs.count else { return false }

    return lhs.enumerate().reduce(true) { (acc: Bool, row: IdentifiableRow) in
        acc && rhs[row.index].isEqual(to: row.identifiable)
    }
}
