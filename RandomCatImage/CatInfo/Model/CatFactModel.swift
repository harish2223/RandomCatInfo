//
//  CatFactModel.swift
//  RandomCatImage
//
//  Created by Harish Gajabheenkar on 17/10/24.
//

import Foundation
struct CatFact: Codable {
    let data: [String]
}


// Mock Data for testing
extension CatFact {
    static func dummyCatFactModelData()-> CatFact {
        return CatFact(data: ["Adult cats only meow to communicate with humans."])
    }
}
