//
//  NetworkMonitor.swift
//  APOD
//
//  Created by Михаил Мезенцев on 06.06.2022.
//

import Network

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue(label: "Monitor")
    private let monitor = NWPathMonitor()
    
    private(set) var isConnected = false
    
    private init() {}
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
