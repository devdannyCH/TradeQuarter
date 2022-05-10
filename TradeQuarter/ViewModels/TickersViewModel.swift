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
    @Published public var isConnected: Bool = true
    @Published public var showSyncAnimation: Bool = false
    
    private var repository: TickerRepositoryProtocol
    private let networkMonitor: NetworkMonitorProtocol
    private var disposables = Set<AnyCancellable>()
    private var timer: Timer?
    
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
    
    public func syncTickersEvery5s(){
        if let timer = timer {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            self.syncTickers()
        }
        timer?.fire()

    }
    
    public func syncTickers() {
        guard !isLoading && isConnected else { return }
        isLoading = true
        repository.syncTickers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    self.error = nil
                    break
                }
                self.isLoading = false
            }) { _ in
                self.showSyncAnimation = true;
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.showSyncAnimation = false;
                 }
            }
            .store(in: &disposables)
    }
}
