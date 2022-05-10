//
//  TickerDTO.swift
//  TradeQuarter
//
//  Created by Danny Dev on 06.05.22.

import Alamofire

typealias TickersDTO = [TickerDTO]

public struct TickerDTO: Equatable {
    let symbol: String
    let lastPrice:Double
    let dailyChange: Double
    
    public static func == (lhs: TickerDTO, rhs: TickerDTO) -> Bool {
        return
            lhs.symbol == rhs.symbol
    }
}
