//
//  CatImageModel.swift
//  RandomCatImage
//
//  Created by Harish Gajabheenkar on 17/10/24.
//

import Foundation
struct CatImage: Codable {
    let id: String
    let url: String
    let width, height: Int
}
typealias catImages = [CatImage]

// For MockData
extension CatImage {
    static func dummyCatImageModelData()-> catImages {
    return [CatImage(id: "aqm", url: "https://cdn2.thecatapi.com/images/aqm.jpg", width: 500, height: 500)]
    }
}
