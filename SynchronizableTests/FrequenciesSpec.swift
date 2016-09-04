//
//  FrequenciesSpec.swift
//  Synchronizable
//
//  Created by Romain Pouclet on 2016-09-04.
//  Copyright © 2016 Perfectly-Cooked. All rights reserved.
//

import Nimble
import Quick
@testable import Synchronizable

class FrequenciesSpec: QuickSpec {

    override func spec() {
        context("When applied on a collection of Heroes") {
            let heroes: [Hero] = [
                Hero(name: "Spider-Man", brand: .Marvel),
                Hero(name: "Batman", brand: .DC),
                Hero(name: "Zephyr", brand: .Valiant),
                Hero(name: "Green-Lantern", brand: .DC),
                Hero(name: "Dr Strange", brand: .Marvel),
                Hero(name: "Blue Beetle", brand: .DC)
            ]

            describe("resulting frequencies") {
                let result = frequencies(heroes) { $0.brand }

                it("should return 2 marvel heroes") {
                    expect(result[.Marvel]).to(equal(2))
                }

                it("should return one Valiant hero") {
                    expect(result[.Valiant]).to(equal(1))
                }

                it("should return 3 DC heroes") {
                    expect(result[.DC]).to(equal(3))
                }
            }
        }

        context("When applied on a collection of Diff") {
            let diffs: [Diff] = [
                .Insert(GithubRepository(identifier: "ReactiveCocoa")),
                .Insert(GithubRepository(identifier: "RxSwift")),
                .Update(GithubRepository(identifier: "Synchronizable")),
                .Update(GithubRepository(identifier: "Kingfisher")),
                .Update(GithubRepository(identifier: "SwiftyJSON")),
                .Delete(identifier: "Argo"),
                .Delete(identifier: "ObjectMapper"),
                .Delete(identifier: "ReactKit"),
                .Delete(identifier: "Alamofire"),
                .None
            ]

            describe("resulting frequencies") {
                let result = frequencies(diffs) { $0.key }

                it("should return 2 Insert diffs") {
                    expect(result["Insert"]).to(equal(2))
                }

                it("should return 3 Update diffs") {
                    expect(result["Update"]).to(equal(3))
                }

                it("should return 4 Delete diffs") {
                    expect(result["Delete"]).to(equal(4))
                }

                it("should return 1 None diff") {
                    expect(result["None"]).to(equal(1))
                }
            }
        }
    }
}

enum Brand: String {
    case Marvel
    case DC
    case Valiant
}

struct Hero {
    let name: String
    let brand: Brand
}
