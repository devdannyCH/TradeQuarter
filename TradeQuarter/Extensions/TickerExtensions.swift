//
//  Ticker.swift
//  TradeQuarter
//
//  Created by Danny Dev on 04.05.22.
//
import CoreData

// MARK: CoreData predicates
extension Ticker {
    static func searchBySymbolPredicate(query: String) -> NSPredicate {
      NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(symbol), query)
    }
    
}

// MARK: Calculated attributes
extension Ticker {

    var decreasing: Bool {
        return self.dailyChange < 0
    }
}
