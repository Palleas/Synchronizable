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
            let synchronizables: [SynchronizableType] = (0..<10)
                .map { ("repository\($0)", $0 < 5 ? "updated" : "not-updated" ) }
                .map(GithubRepository.init)

            let persistables: [Persistable] = (3..<12)
                .map { ("repository\($0)", "not-updated") }
                .map(Repository.init)

            context("When the persistence store is empty") {

                describe("the resulting diff array") {
                    let result = Diff.reducer(local: [], remote: synchronizables)

                    it("should contain as much elements as the synchronizable input") {
                        expect(result.count).to(equal(synchronizables.count))
                    }

                    it("should contain only Insert diff") {
                        let freqs = frequencies(result) { $0.key }

                        expect(freqs.count).to(equal(1))
                        expect(freqs["Insert"]).to(equal(synchronizables.count))
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
                    let freqs = frequencies(result) { $0.key }

                    it("should contain as much elements as the synchronizable input") {
                        expect(result.count).to(equal(synchronizables.count))
                    }

                    it("should return 3 Insert") {
                        expect(freqs["Insert"]).to(equal(3))
                    }

                    it("should return Insert diffs that match the new Synchronizables") {
                        let match: Bool = result
                            .enumerate()
                            .filter { $0.element.isInsert }
                            .reduce(true) { acc, row in
                                let rhs = synchronizables[row.index]
                                guard case .Insert(let lhs) = row.element else { return false }
                                return lhs.identifier == rhs.identifier
                            }
                        expect(match).to(beTrue())
                    }

                    it("should return 2 Update") {
                        expect(freqs["Update"]).to(equal(2))
                    }

                    it("should return Update diffs that match the updated Synchronizables") {
                        let match: Bool = result
                            .enumerate()
                            .filter { $0.element.isUpdate }
                            .reduce(true) { acc, row in
                                let rhs = synchronizables[row.index]
                                guard case .Update(let lhs) = row.element else { return false }
                                return lhs.identifier == rhs.identifier
                        }
                        expect(match).to(beTrue())
                    }

                    it("should return 5 None") {
                        expect(freqs["None"]).to(equal(2))
                    }

                    it("should return 3 Delete") {
                        expect(freqs["Delete"]).to(equal(3))
                    }

                    it("should return Update diffs that wrap the identifiers of the deleted Persistables") {
                        let match: Bool = result
                            .enumerate()
                            .filter { $0.element.isDelete }
                            .reduce(true) { acc, row in
                                guard case .Delete(let identifier) = row.element else { return false }
                                return identifier == synchronizables[row.index].identifier
                        }
                        expect(match).to(beTrue())
                    }
                }
            }
        }
    }
}

extension Diff {
    var isInsert: Bool {
        guard case .Insert(_) = self else { return false }
        return true
    }

    var isUpdate: Bool {
        guard case .Update(_) = self else { return false }
        return true
    }

    var isDelete: Bool {
        guard case .Delete(_) = self else { return false }
        return true
    }
}
