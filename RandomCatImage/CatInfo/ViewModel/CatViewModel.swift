//
//  CatViewModel.swift
//  RandomCatImage
//
//  Created by Harish Gajabheenkar on 17/10/24.
//

import Foundation

class CatViewModel {
    private let catFactService: CatFactServiceProtocol
    private let catImageService: CatImageServiceProtocol
    
    var catFact: ((String) -> Void)?
    var catImage: ((String) -> Void)?
    var errorHandler: ((String) -> Void)?
    
    init(catFactService: CatFactServiceProtocol,catImageService: CatImageServiceProtocol) {
        self.catFactService = catFactService
        self.catImageService = catImageService
    }
    
    func fetchCatData() async {
            do {
                async let fact = try catFactService.getRandomCatFact()
                async let image = try catImageService.getRandomCatImage()
                let catFact = try await fact
                let catImage = try await image
                self.catFact?(catFact.data.first ?? "")
                self.catImage?(catImage.first?.url ?? "")
            } catch {
                self.errorHandler?(error.localizedDescription)
            }
    }
}
