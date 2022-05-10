//
//  NetworkMonitor.swift
//  TradeQuarter
//
//  Created by Danny Dev on 09.05.22.
//

import Combine
import Network

protocol NetworkMonitorProtocol {
    var isConnected: PassthroughSubject<Bool, Never> { get }
}

class NetworkMonitor: NetworkMonitorProtocol {
    var isConnected: PassthroughSubject<Bool, Never> = .init()
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let monitor = NWPathMonitor()
    private var disposables = Set<AnyCancellable>()

    init() {
        monitor.pathUpdateHandler = { path in
            print(self.monitor.currentPath.status == .satisfied)
            self.isConnected.send(self.monitor.currentPath.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
    
}
