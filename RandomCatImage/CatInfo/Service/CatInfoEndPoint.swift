//
//  CatInfoEndPoint.swift
//  RandomCatImage
//
//  Created by Harish Gajabheenkar on 17/10/24.
//

import Foundation

typealias StringArr = [String: String]

enum CatInfoEndPoint {
    case catFact
    case catImage
}

extension CatInfoEndPoint: EndPoint {
    
    var host: String {
        switch self {
        case .catFact:
            return "meowfacts.herokuapp.com"
        case .catImage:
            return "api.thecatapi.com"
        }
    }
    
    var path: String {
        switch self {
        case .catImage:
            return "/v1/images/search"
        case .catFact:
            return ""
        }
        }
    
    var method: RequestType {
        return .get
    }
    
    var header: StringArr? {
        return ["Content-Type": "application/json"]
    }
    
    var body: StringArr? {
        return nil
    }
    
    var queryParams: StringArr? {
        return [:]
    }
    
    var pathParams: StringArr? {
        return [:]
    }
}

