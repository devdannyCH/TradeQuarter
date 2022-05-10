//
//  TickerService.swift
//  TradeQuarter
//
//  Created by Danny Dev on 06.05.22.
//

import Foundation
import Combine
import Alamofire

public enum NetworkError: Error {
    case responseError
}

public protocol TickerServiceProtocol {
    func getTickers() -> AnyPublisher<[TickerDTO], Error>
}


public final class BitfinexTickerService: TickerServiceProtocol {
    
    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }
    
    public func getTickers() -> AnyPublisher<[TickerDTO], Error> {
        let url = URL(string: Bitfinex.tickersEndpoint)!
        return session.request(url, method: .get)
        .validate()
        .publishData()
        .value()
        .tryMap{ data in
            do{
                if let tickersArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[Any]]{
                   return try tickersArray.compactMap{try TickerDTO.init(jsonArray: $0)}
                }else{
                    throw NetworkError.responseError
                }
            }catch{
                throw NetworkError.responseError
            }
        }
        .mapError{TickersError.networkError(error: $0)}
        .eraseToAnyPublisher()
    }
}
