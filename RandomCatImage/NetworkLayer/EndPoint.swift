//
//  EndPoint.swift
//  RandomCatImage
//
//  Created by Harish on 26/07/24.
//

import Foundation

protocol EndPoint {
    var host: String { get }
    var scheme: String { get }
    var path: String { get }
    var method: RequestType { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryParams: [String: String]? { get } // Added for query parameters
    var pathParams: [String: String]? { get }  // Added for path parameters
}

extension EndPoint {
    var scheme: String {
        return "https"
    }
}
