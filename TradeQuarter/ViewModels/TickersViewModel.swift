//
//  TickersViewModel.swift
//  TradeQuarter
//
//  Created by Danny Dev on 06.05.22.
//

import SwiftUI
import Combine
import Network

class TickersViewModel: ObservableObject {
    
    @Published public var error: TickersError? = nil
    @Published public var isLoading: Bool = false
    @Published public var isConnected: Bool = false
    
    private var repository: TickerRepositoryProtocol
    private let networkMonitor: NetworkMonitorProtocol
    private var disposables = Set<AnyCancellable>()
    
    init(repository: TickerRepositoryProtocol = TickerRepository(), networkMonitor: NetworkMonitorProtocol = NetworkMonitor()){
        self.repository = repository
        self.networkMonitor = networkMonitor
        self.networkMonitor.isConnected
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { isConnected in
                self.isConnected = isConnected
            })
            .store(in: &disposables)
    }
    
    public func syncTickers() {
        guard !isLoading && isConnected else { return }
        isLoading = true
        repository.syncTickers()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    break
                }
                self.isLoading = false
            }) { result in
                print("Synced tickers: \(result)")
            }
            .store(in: &disposables)
    }
}
