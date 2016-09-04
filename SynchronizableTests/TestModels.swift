//
//  TestModels.swift
//  Synchronizable
//
//  Created by Romain Pouclet on 2016-09-04.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Foundation
@testable import Synchronizable

struct GithubRepository: Synchronizable {
    let identifier: String

    func compare(against persistable: Persistable) -> Diff {
        return .Insert(self)
    }
}

struct Repository: Persistable {
    let identifier: String
}
