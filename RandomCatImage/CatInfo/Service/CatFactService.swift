//
//  CatFactService.swift
//  RandomCatImage
//
//  Created by Harish Gajabheenkar on 17/10/24.
//

import Foundation

protocol CatFactServiceProtocol {
    func getRandomCatFact() async throws -> CatFact
}

struct CatFactService {
    
    private let networkService: Networkable
    
    init(networkService: Networkable = NetworkService()) {
        self.networkService = networkService
    }
}

extension CatFactService : CatFactServiceProtocol {
    func getRandomCatFact() async throws -> CatFact {
        
        let catFactData = try await networkService.sendRequest(endpoint: CatInfoEndPoint.catFact) as CatFact
        guard catFactData.data.isNotEmpty else {
            throw NetworkError.decode
        }
        return catFactData
    }
}
