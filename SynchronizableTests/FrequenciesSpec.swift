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
