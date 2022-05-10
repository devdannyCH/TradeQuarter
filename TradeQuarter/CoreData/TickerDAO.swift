//
//  TickerDAO.swift
//  TradeQuarter
//
//  Created by Danny Dev on 06.05.22.
//

import SwiftUI
import CoreData
import Combine

public protocol TickerDaoProtocol {
    func update(_ entities: [TickerDTO]) -> Future<[Ticker], Error>
}

class TickerDao: TickerDaoProtocol {
    
    private let viewContext: NSManagedObjectContext;
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }

    
    func update(_ entities: [TickerDTO]) -> Future<[Ticker ], Error> {
        Future<[Ticker], Error> { output in
            do{
                var tickers: [Ticker] = []
                for tickerDTO in entities {
                    tickers.append(try self.addTicker(from: tickerDTO))
                }
                output(.success(tickers))
            }catch {
                output(.failure(error))
            }
        }
    }
    
    private func addTicker(from dto: TickerDTO) throws -> Ticker {
        let newTicker = Ticker(context: viewContext)
        newTicker.symbol = dto.symbol
        newTicker.lastPrice = dto.lastPrice
        newTicker.dailyChange = dto.dailyChange
        do {
            try viewContext.save()
            return newTicker;
        } catch {
            throw TickersError.peristenceError(error: error)
        }
    }
}
