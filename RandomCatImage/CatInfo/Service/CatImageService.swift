//
//  CatImageService.swift
//  RandomCatImage
//
//  Created by Harish Gajabheenkar on 17/10/24.
//

import Foundation

protocol CatImageServiceProtocol {
    func getRandomCatImage() async throws -> catImages
}

struct CatImageService {
    
    private let networkService: Networkable
    
    init(networkService: Networkable = NetworkService()) {
        self.networkService = networkService
    }
}

extension CatImageService : CatImageServiceProtocol {
    func getRandomCatImage() async throws -> catImages {
        
        let catImageData = try await networkService.sendRequest(endpoint: CatInfoEndPoint.catImage) as catImages
        guard catImageData.isNotEmpty else {
            throw NetworkError.decode
        }
        return catImageData
    }
}
