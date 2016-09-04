//
//  DiffReducerSpec.swift
//  DiffReducerSpec
//
//  Created by Romain Pouclet on 2016-09-04.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Quick
import Nimble
@testable import Synchronizable

class DiffReducerSpec: QuickSpec {
    
    override func spec() {
        describe("The Diff Reducer") {
            let synchronizables: [Synchronizable] = (0..<10)
                .map { "repository\($0)" }
                .map(GithubRepository.init)

            let persistables: [Persistable] = (3..<12)
                .map { "repository\($0)" }
                .map(Repository.init)

            context("When the persistence store is empty") {

                describe("the resulting diff array") {
                    let result = Diff.reducer(local: [], remote: synchronizables)

                    it("should contain as much elements as the synchronizable input") {
                        expect(result.count).to(equal(synchronizables.count))
                    }

                    it("should contain only Insert diff") {
                        let inserts = result.filter {
                            guard case .Insert(_) = $0 else { return false }

                            return true
                        }

                        expect(inserts.count).to(equal(synchronizables.count))
                    }

                    it("should return Insert diffs that match the Synchronizables") {
                        let wrappedSynchronizables: [Identifiable] = result
                            .map {
                                guard case .Insert(let synchronizable) = $0 else { return nil }

                                return synchronizable
                            }
                            .flatMap { $0 }
                        let matches = compare(wrappedSynchronizables, synchronizables.map { $0 as Identifiable })

                        expect(matches).to(beTrue())
                    }
                }
            }

            context("When the persistence store contains Persistables") {
                describe("the resulting diff array") {
                    let result = Diff.reducer(local: persistables, remote: synchronizables)

                    it("should contain as much elements as the synchronizable input") {
                        expect(result.count).to(equal(synchronizables.count))
                    }

                    
                }
            }
        }
    }
}
