//
//  NetworkMonitor.swift
//  TradeQuarter
//
//  Created by Danny Dev on 09.05.22.
//

import Combine
import Network

protocol NetworkMonitorProtocol {
    var isConnected: CurrentValueSubject<Bool, Never> { get }
}

class NetworkMonitor: NetworkMonitorProtocol {
    var isConnected: CurrentValueSubject<Bool, Never>
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let monitor = NWPathMonitor()
    private var disposables = Set<AnyCancellable>()

    init() {
        isConnected = CurrentValueSubject<Bool, Never>.init(monitor.currentPath.status == .satisfied)
        monitor.pathUpdateHandler = { path in
            self.isConnected.send(self.monitor.currentPath.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
    
}
