//
//  NetworkMonitor.swift
//  RandomCatImage
//
//  Created by Harish on 26/07/24.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    var isReachable: Bool { status == .satisfied }
    private let monitor = NWPathMonitor()
    private var status = NWPath.Status.requiresConnection

    private init() {
        startMonitoring()
    }
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
