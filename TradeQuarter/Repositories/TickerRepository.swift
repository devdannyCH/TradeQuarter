//
//  TickerRepository.swift
//  TradeQuarter
//
//  Created by Danny Dev on 06.05.22.
//

import Combine
import Network

public enum TickersError: Error {
    case networkError(error: Error)
    case peristenceError(error: Error)
    case unknownError(error: Error)
}

public protocol TickerRepositoryProtocol {
    
    func syncTickers() -> AnyPublisher<[Ticker], TickersError>
}

public final class TickerRepository: TickerRepositoryProtocol {
    
    private var service: TickerServiceProtocol = BitfinexTickerService()
    private var dao: TickerDaoProtocol = TickerDao()
    
    
    init(service: TickerServiceProtocol = BitfinexTickerService(), dao: TickerDaoProtocol = TickerDao()) {
        self.service = service
        self.dao = dao
    }
    
    public func syncTickers() -> AnyPublisher<[Ticker], TickersError> {
        service.getTickers()
            .flatMap { tickers in
                self.dao.update(tickers)
            }
            .mapError{ error in
                if error is TickersError
                {
                    return error as! TickersError
                }else{
                    return TickersError.unknownError(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
}
