//
//  Networkable.swift
//  RandomCatImage
//
//  Created by Harish on 26/07/24.
//

import Foundation

protocol Networkable {
    func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T
}

final class NetworkService: Networkable {
    func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T {
        guard let urlRequest = createRequest(endPoint: endpoint) else {
            throw NetworkError.decode
        }
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
                .dataTask(with: urlRequest) { data, response, _ in
                    guard response is HTTPURLResponse else {
                        continuation.resume(throwing: NetworkError.invalidURL)
                        return
                    }
                    guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                        continuation.resume(throwing:
                                                NetworkError.unexpectedStatusCode)
                        return
                    }
                    guard let data = data else {
                        continuation.resume(throwing: NetworkError.unknown)
                        return
                    }
                    guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                        continuation.resume(throwing: NetworkError.decode)
                        return
                    }
                    continuation.resume(returning: decodedResponse)
                }
            task.resume()
        }
    }

    init() {

    }
}

extension Networkable {
    fileprivate func createRequest(endPoint: EndPoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        // Adding query parameters
        urlComponents.queryItems = endPoint.queryParams?.map { URLQueryItem(name: $0.key, value: $0.value) }

        // Handling path parameters
        var path = endPoint.path
        for (key, value) in endPoint.pathParams ?? [:] {
            path = path.replacingOccurrences(of: "{\(key)}", with: value)
        }
        urlComponents.path = path
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.header
        if let body = endPoint.body {
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(body)
        }
        return request
    }
}

